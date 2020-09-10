GOMAXPROCS:=$(shell nproc)

.PHONY: test
test:
	@mkdir -p tmp
	@echo "mode: atomic" > tmp/cover.out
	@for d in $(shell go list ./... | grep -v vendor); do \
		go test -race -timeout 20s -coverprofile=tmp/pkg.out -covermode=atomic "$$d" || exit 1; \
		tail -n +2 tmp/pkg.out >> tmp/cover.out && \
		rm tmp/pkg.out; \
	done
	@go tool cover -html=tmp/cover.out -o tmp/coverage.html

.PHONY: bench
bench:
	@GOMAXPROCS=$(GOMAXPROCS) go test -bench=. -benchmem ./...
