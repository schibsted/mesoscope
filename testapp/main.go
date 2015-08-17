package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", h)
	http.ListenAndServe(":8001", nil)
}

func h(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello world")
}
