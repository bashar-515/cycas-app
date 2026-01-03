package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"


	_ "github.com/joho/godotenv/autoload"

	"codeberg.org/cycas/app/app/lib/server"
	"codeberg.org/cycas/app/app/lib/store/postgres"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()

	connString, ok := os.LookupEnv("CYCAS_DATABASE_URL")
	if !ok {
		// TODO: handle case
	}

	store, err := postgres.New(ctx, connString)
	if err != nil {
		// TODO: handle error
	}
	defer store.Close()

	handler, err := server.NewServer(store).Handler()
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
			// TODO: don't call `log.Fatalf` in this Go routine; instead, use a cancel the context to trigger shutdown
			log.Fatalf("error listening and serving: %v", err)
		}
	}()
	
	<-ctx.Done()

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer shutdownCancel()

	if err = srv.Shutdown(shutdownCtx); err != nil {
		log.Fatalf("error shutting server down: %v", err)
	}
}
