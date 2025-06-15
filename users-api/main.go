package main

import (
	"encoding/json"
	"net/http"
)

func main() {
	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		// ✅ Add CORS header
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Content-Type", "application/json")
		
		json.NewEncoder(w).Encode(map[string]string{
			"message": "Hello from Go backend 👋",
		})
	})

	http.ListenAndServe(":8080", nil)
}
