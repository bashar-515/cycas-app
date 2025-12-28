package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"codeberg.org/cycas/app/src/lib/server"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()

	handler, err := server.NewServer().Handler()
	if err != nil {
		log.Fatalf("error getting server handler: %v", err)
	}

	srv := &http.Server{
		Addr: ":8000",
		Handler: handler,
		// TODO: [q] do any other fields need to be set?
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("error listening and serving: %v", err)
		}
	}()
	
	<-ctx.Done()

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err = srv.Shutdown(shutdownCtx); err != nil {
		log.Fatalf("error shutting server down: %v", err)
	}
}
