package main

import (
	"fmt"

	"codeberg.org/cycas/app/internal/config"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		// TODO: handle error
	}

	fmt.Println(cfg.DatabaseUrl)
}
