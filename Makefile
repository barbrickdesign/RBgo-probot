.PHONY: help test lint fmt mod-tidy clean install coverage generate

# Default target
help: ## Display this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

test: ## Run tests with race detector
	go test -v --race ./...

lint: ## Run golangci-lint (requires golangci-lint to be installed)
	@which golangci-lint > /dev/null || (echo "golangci-lint not found. Install it from https://golangci-lint.run/usage/install/" && exit 1)
	golangci-lint run ./...

fmt: ## Format Go code
	go fmt ./...
	@which goimports > /dev/null && goimports -w . || echo "Tip: Install goimports for better formatting: go install golang.org/x/tools/cmd/goimports@latest"

mod-tidy: ## Tidy and verify Go modules
	go mod tidy
	go mod verify

clean: ## Remove build artifacts and cache
	go clean -cache -testcache -modcache
	rm -rf web/dist

install: ## Install Go dependencies
	go mod download

coverage: ## Run tests with coverage report
	go test -v --race -coverprofile=coverage.out -covermode=atomic ./...
	go tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report generated: coverage.html"

generate: ## Build web dashboard
	cd web/dashboard && \
	npm run build
