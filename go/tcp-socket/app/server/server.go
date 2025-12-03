// server/main.go
package main

import (
	"fmt"
	"net"
)

func main() {

	//	Listen on all interfaces
	//	NOT "localhost:9000"
	//  Binding to "localhost:8080" will prevent other containers from connecting.

	listener, err := net.Listen("tcp", ":9000")
	
	if err != nil {
		panic(err)
	}
	fmt.Println("TCP Server listening on :9000")

	for {
		conn, err := listener.Accept()
		if err != nil {
			continue
		}
		go handle(conn)
	}
}

func handle(conn net.Conn) {
	defer conn.Close()
	buf := make([]byte, 1024)

	for {
		n, err := conn.Read(buf)
		if err != nil {
			fmt.Println("Client disconnected")
			return
		}
		msg := string(buf[:n])
		fmt.Println("Received:", msg)
	}
}

