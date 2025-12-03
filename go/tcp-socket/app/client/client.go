// client/main.go
package main

import (
	"fmt"
	"net"
	"time"
)

func main() {
	for {
		conn, err := net.Dial("tcp", "server:9000")

		// server is the name of the service in docker-compose.yml

		if err != nil {
			fmt.Println("Retrying to connect...")
			time.Sleep(2 * time.Second)
			continue
		}

		for {
			msg := fmt.Sprintf("Hello from client at %s", time.Now().Format(time.RFC3339))
			fmt.Println("Sending:", msg)
			conn.Write([]byte(msg))
			time.Sleep(5 * time.Second)
		}
	}
}

