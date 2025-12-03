package main

import (
	"fmt"
	"net"
)

func main() {
	addr := net.UDPAddr{
		Port: 9000,
		IP:   net.ParseIP("0.0.0.0"), // listen on all interfaces
	}

	conn, err := net.ListenUDP("udp", &addr)
	if err != nil {
		panic(err)
	}
	defer conn.Close()

	fmt.Println("UDP server listening on :9000")

	buf := make([]byte, 1024)
	for {
		n, clientAddr, err := conn.ReadFromUDP(buf)
		if err != nil {
			fmt.Println("Error:", err)
			continue
		}
		fmt.Printf("Received from %s: %s\n", clientAddr.String(), string(buf[:n]))
	}
}

