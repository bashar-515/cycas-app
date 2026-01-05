package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"codeberg.org/cycas/app/internal/config"
	"codeberg.org/cycas/app/internal/server"
	"codeberg.org/cycas/app/internal/store/postgres"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()

	cfg, err := config.Load()
	if err != nil {
		// TODO: handle error
	}

	store, err := postgres.New(ctx, cfg.DatabaseUrl)
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
