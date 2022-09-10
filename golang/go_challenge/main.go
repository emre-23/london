package main

import (
	"fmt"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<h1>Hi to all from Emre</h1>")
}

func main() {
	http.HandleFunc("/", index)
	fmt.Println("Server is starting...")
	http.ListenAndServe(":80", nil)
}
