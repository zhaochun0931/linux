package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"github.com/hashicorp/raft"
	raftbolt "github.com/hashicorp/raft-boltdb/v2"
)

// --- 1. Database State Machine (FSM) ---
type DatabaseFSM struct {
	mu sync.RWMutex
	DB map[string]string
}

func (fsm *DatabaseFSM) Apply(l *raft.Log) interface{} {
	var payload struct{ Key, Value string }
	json.Unmarshal(l.Data, &payload)

	fsm.mu.Lock()
	defer fsm.mu.Unlock()
	fsm.DB[payload.Key] = payload.Value
	fmt.Printf("[DB] Inserted: %s = %s\n", payload.Key, payload.Value)
	return nil
}

func (fsm *DatabaseFSM) Snapshot() (raft.FSMSnapshot, error) {
	fsm.mu.RLock()
	defer fsm.mu.RUnlock()
	dbCopy := make(map[string]string)
	for k, v := range fsm.DB {
		dbCopy[k] = v
	}
	return &dbSnapshot{dbState: dbCopy}, nil
}

func (fsm *DatabaseFSM) Restore(rc io.ReadCloser) error {
	fsm.mu.Lock()
	defer fsm.mu.Unlock()
	err := json.NewDecoder(rc).Decode(&fsm.DB)
	fmt.Printf("[DB] Restored %d keys from disk.\n", len(fsm.DB))
	return err
}

type dbSnapshot struct{ dbState map[string]string }

func (s *dbSnapshot) Persist(sink raft.SnapshotSink) error {
	err := json.NewEncoder(sink).Encode(s.dbState)
	if err != nil {
		sink.Cancel()
		return err
	}
	return sink.Close()
}
func (s *dbSnapshot) Release() {}

// --- 2. Main Application ---
func main() {
	nodeID := flag.String("id", "node1", "Unique Node ID")
	raftPort := flag.String("raft", "7000", "Raft TCP Port")
	httpPort := flag.String("http", "8000", "REST API Port")
	bootstrap := flag.Bool("bootstrap", false, "Start as cluster leader")
	joinAddr := flag.String("join", "", "Leader HTTP address to auto-join (e.g., localhost:8000)")
	flag.Parse()

	baseDir := filepath.Join("data", *nodeID)
	_ = os.MkdirAll(baseDir, 0755)

	raftAddr := fmt.Sprintf("127.0.0.1:%s", *raftPort)
	config := raft.DefaultConfig()
	config.LocalID = raft.ServerID(*nodeID)

	// Persistence Layer
	logStore, _ := raftbolt.NewBoltStore(filepath.Join(baseDir, "raft-log.db"))
	stableStore, _ := raftbolt.NewBoltStore(filepath.Join(baseDir, "raft-stable.db"))
	snapshotStore, _ := raft.NewFileSnapshotStore(baseDir, 3, os.Stderr)

	// Network Transport
	addr, _ := net.ResolveTCPAddr("tcp", raftAddr)
	transport, _ := raft.NewTCPTransport(raftAddr, addr, 3, 10*time.Second, os.Stderr)

	fsm := &DatabaseFSM{DB: make(map[string]string)}
	r, err := raft.NewRaft(config, fsm, logStore, stableStore, snapshotStore, transport)
	if err != nil {
		panic(err)
	}

	// --- 3. REST API Server ---
	go func() {
		// API: Join Cluster
		http.HandleFunc("/join", func(w http.ResponseWriter, req *http.Request) {
			if r.State() != raft.Leader {
				http.Error(w, "Not Leader", http.StatusForbidden)
				return
			}
			id, joinAddr := req.URL.Query().Get("id"), req.URL.Query().Get("addr")
			fmt.Printf("[API] Auto-joining node %s at %s...\n", id, joinAddr)
			r.AddVoter(raft.ServerID(id), raft.ServerAddress(joinAddr), 0, 0)
			w.Write([]byte("ok"))
		})

		// API: Safe Downscale (Remove a Node)
		http.HandleFunc("/remove", func(w http.ResponseWriter, req *http.Request) {
			if r.State() != raft.Leader {
				http.Error(w, "Error: Must send remove requests to the Leader", http.StatusForbidden)
				return
			}
			nodeToRemove := req.URL.Query().Get("id")
			future := r.RemoveServer(raft.ServerID(nodeToRemove), 0, 0)
			if err := future.Error(); err != nil {
				http.Error(w, "Failed to remove node", http.StatusInternalServerError)
				return
			}
			fmt.Fprintf(w, "Successfully removed %s. Quorum math updated!\n", nodeToRemove)
		})

		// API: Write Data (with Proxy)
		http.HandleFunc("/set", func(w http.ResponseWriter, req *http.Request) {
			if r.State() != raft.Leader {
				leaderRaftAddr := string(r.Leader())
				if leaderRaftAddr == "" {
					http.Error(w, "Cluster has no leader right now", http.StatusServiceUnavailable)
					return
				}

				// Proxy logic: convert Raft port (700x) to HTTP port (800x)
				leaderHTTPAddr := leaderRaftAddr[:strings.LastIndex(leaderRaftAddr, ":")+1] +
					"8" + leaderRaftAddr[strings.LastIndex(leaderRaftAddr, ":")+2:]

				forwardURL := fmt.Sprintf("http://%s%s?%s", leaderHTTPAddr, req.URL.Path, req.URL.RawQuery)
				fmt.Printf("[PROXY] Forwarding write request to Leader at %s\n", forwardURL)

				resp, err := http.Get(forwardURL)
				if err != nil {
					http.Error(w, "Failed to forward request to leader", http.StatusInternalServerError)
					return
				}
				defer resp.Body.Close()

				w.WriteHeader(resp.StatusCode)
				io.Copy(w, resp.Body)
				return
			}

			key, val := req.URL.Query().Get("key"), req.URL.Query().Get("value")
			payload, _ := json.Marshal(map[string]string{"Key": key, "Value": val})

			future := r.Apply(payload, 2*time.Second)
			if err := future.Error(); err != nil {
				http.Error(w, "Failed to write data", http.StatusInternalServerError)
				return
			}
			fmt.Fprintf(w, "Success! %s = %s\n", key, val)
		})

		// API: Read Data
		http.HandleFunc("/get", func(w http.ResponseWriter, req *http.Request) {
			fsm.mu.RLock()
			val, exists := fsm.DB[req.URL.Query().Get("key")]
			fsm.mu.RUnlock()
			if !exists {
				http.Error(w, "Key not found", http.StatusNotFound)
				return
			}
			fmt.Fprintf(w, "%s\n", val)
		})

		// API: Cluster Info
		http.HandleFunc("/info", func(w http.ResponseWriter, req *http.Request) {
			fmt.Fprintf(w, "Node: %s | State: %s | Keys: %d\n", *nodeID, r.State(), len(fsm.DB))
		})

		http.ListenAndServe(":"+*httpPort, nil)
	}()

	// --- 4. SMART STARTUP & AUTO-JOIN LOGIC ---
	hasState, _ := raft.HasExistingState(logStore, stableStore, snapshotStore)

	if *bootstrap && !hasState {
		fmt.Println("Bootstrapping new cluster...")
		r.BootstrapCluster(raft.Configuration{
			Servers: []raft.Server{{ID: config.LocalID, Address: transport.LocalAddr()}},
		})
	} else if *joinAddr != "" && !hasState {
		go func() {
			joinURL := fmt.Sprintf("http://%s/join?id=%s&addr=%s", *joinAddr, *nodeID, raftAddr)
			for {
				fmt.Printf("Attempting to auto-join cluster via %s...\n", *joinAddr)
				resp, err := http.Get(joinURL)
				if err == nil && resp.StatusCode == http.StatusOK {
					fmt.Println("Successfully joined the cluster!")
					return
				}
				time.Sleep(2 * time.Second)
			}
		}()
	} else if hasState {
		fmt.Println("Existing database found. Recovering from disk...")
	}

	select {}
}
