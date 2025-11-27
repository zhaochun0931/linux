package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()
		fmt.Printf("Request hit backend: %s\n", hostname)
		fmt.Fprintf(w, "Hello from Go backend: %s\n", hostname)
	})

	fmt.Println("Go backend running on port 3000")
	http.ListenAndServe(":3000", nil)
}

