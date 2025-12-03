package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()
		fmt.Fprintf(w, "Hello from %s\n", hostname)
	})

	fmt.Println("Server running on :8080")
	http.ListenAndServe(":8080", nil)
}

