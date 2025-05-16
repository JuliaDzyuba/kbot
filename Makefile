#APP=$(basename $(shell git remote get-url origin))
APP=kbot
REGISTRY=juliadzyuba
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS?=linux
TARGETARCH?=arm64

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/juliadzyuba/kbot/cmd.appVersion=${VERSION}

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=amd64

macos:
	$(MAKE) build TARGETOS=darwin TARGETARCH=amd64

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=amd64 BIN_NAME=kbot.exe

arm:
	$(MAKE) build TARGETOS=linux TARGETARCH=arm64

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
