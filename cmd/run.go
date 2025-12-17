package main

import (
	"log"
	"net/http"

	"codeberg.org/cycas/app/src/lib/server"
)

func main() {
	handler, err := server.NewServer().Handler()
	if err != nil {
		log.Fatal(err)
	}

	http.ListenAndServe(":8000", handler)
}
