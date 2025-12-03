package main

import (
	"fmt"
	"net"
	"time"
)

func main() {
	serverAddr, err := net.ResolveUDPAddr("udp", "udp-server:9000") // use service name
	if err != nil {
		panic(err)
	}

	conn, err := net.DialUDP("udp", nil, serverAddr)
	if err != nil {
		panic(err)
	}
	defer conn.Close()

	for {
		msg := fmt.Sprintf("Hello from UDP client at %s", time.Now().Format("15:04:05"))
		_, err := conn.Write([]byte(msg))
		if err != nil {
			fmt.Println("Write error:", err)
		} else {
			fmt.Println("Sent:", msg)
		}
		time.Sleep(5 * time.Second)
	}
}

