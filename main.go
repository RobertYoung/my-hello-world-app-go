package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"
)

var hostname = ""

const (
	PORT = 8080
)

type Response struct {
	Hostname string `json:"hostname"`
	Path     string `json:"path"`
}

func main() {
	getHostname()

	port := strconv.Itoa(PORT)
	fmt.Printf("Listening on port " + port + "\n")

	http.HandleFunc("/", handler)
	http.HandleFunc("/echo", echoHandler)
	http.HandleFunc("/health", healthHandler)
	http.ListenAndServe(":"+port, nil)
}

func getHostname() {
	name, err := os.Hostname()

	if err != nil {
		panic(err)
	}

	hostname = name
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Server is running!")
}

func echoHandler(w http.ResponseWriter, r *http.Request) {
	data := Response{
		Path:     "/" + r.URL.Path[1:],
		Hostname: hostname,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(data)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Passed")
}
