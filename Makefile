GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean

CC=gcc
CC_WIN=i686-w64-mingw32-gcc
CC_ARM=arm-linux-gnueabihf-gcc

GOWIN=CC=$(CC_WIN) CGO_ENABLED=1 GOOS=windows GOARCH=386

GOARM_SHARED=CC=$(CC_ARM) CGO_ENABLED=1 GOOS=linux GOARCH=arm

BINARY_NAME=bootstrap
BINARY_NAME_WIN=bootstrap.exe

all:	clean build build-windows build-shared build-example
build: clean
		$(GOBUILD) -o bin/$(BINARY_NAME) -v src/main.go
build-windows:
		$(GOWIN) $(GOBUILD) -o bin/$(BINARY_NAME_WIN) -v src/main.go
build-shared:
		$(GOBUILD) -o bin/$(BINARY_NAME).so -buildmode=c-shared -v src/main.go
build-shared-arm: clean
		$(GOARM_SHARED) $(GOBUILD) -o bin/$(BINARY_NAME).so -buildmode=c-shared -v src/main.go
build-example: clean build-shared
		$(CC) -o bin/$(BINARY_NAME)_example -I./bin -L./bin example/example.cpp bin/bootstrap.so
clean:
		$(GOCLEAN)
		rm -f bin/$(BINARY_NAME)*
