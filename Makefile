GOTIMEOUT?=20s
GOARGS?=-race
GOMAXPROCS?=$(shell nproc)

.PHONY: test
test:
	@mkdir -p tmp
	@echo "mode: atomic" > tmp/cover.out
	@for d in $(shell go list ./... | grep -v vendor | grep -v demo); do \
		GOMAXPROCS=$(GOMAXPROCS) \
			go test \
			$(GOARGS) \
			-timeout $(GOTIMEOUT) \
			-coverprofile=tmp/pkg.out -covermode=atomic \
			"$$d" || exit 1; \
		tail -n +2 tmp/pkg.out >> tmp/cover.out && \
		rm tmp/pkg.out; \
	done
	@go tool cover -html=tmp/cover.out -o tmp/coverage.html

.PHONY: bench
bench:
	@for d in $(shell go list ./... | grep -v vendor | grep -v demo); do \
		GOMAXPROCS=$(GOMAXPROCS) \
			go test \
			$(GOARGS) \
			-bench=^Benchmark \
			-benchmem \
			"$$d" || exit 1; \
	done

.PHONY: demo
demo:
	@for d in $(shell go list ./... | grep -v vendor | grep demo); do \
		echo "===> Demo: $$d" && \
		go run "$$d" || exit 1; \
	done
