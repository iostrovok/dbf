# Include go binaries into path
export GOPATH:=/Users/vlad/go
export PATH := $(GOPATH)/bin:$(PWD)/bin:$(PATH)

BUILD=$(shell date +%FT%T)
VERSION= $(shell git rev-parse --short HEAD)
LDFLAGS=-ldflags "-w -s -X main.Version=${VERSION} -X main.Build=${BUILD}"

SOURCE_PATH :=TEST_SOURCE_PATH=$(PWD)

GOBIN := $(PWD)/bin/
ENV:=GOBIN=$(GOBIN) RUN_PATH=$(PWD)

# teamcity
install: mod ## Run installing
	@echo "Environment installed"

tests-cover: ## Run test covering
	$(SOURCE_PATH) go test -coverprofile=$(PWD)/coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html
	rm coverage.out


test: ## Run test
	$(SOURCE_PATH) go test ./...

clean-cache: ## Clean golang cache
	@echo "clean-cache started..."
	go clean -cache
	go clean -testcache
	@echo "clean-cache complete!"

clean-vendor: ## Remove vendor folder
	@echo "clean-vendor started..."
	rm -fr ./vendor
	@echo "clean-vendor complete!"


mod: ## Download all dependencies
	@echo "======================================================================"
	@echo "Run MOD...."

# 	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod verify
	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod tidy
	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod vendor
	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod download
# 	GO111MODULE=on GONOSUMDB="*" GOPROXY=direct go mod verify
	@echo "======================================================================"
