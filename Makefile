# Makefile for building Flutter desktop executables for Windows, Mac, and Linux

FLUTTER = flutter

.PHONY: all build clean
''
all: build

build: build_windows build_mac build_linux

build_windows:
	@echo "Building Windows executable..."
	@$(FLUTTER) build windows

build_mac:
	@echo "Building Mac executable..."
	@$(FLUTTER) build macos

build_linux:
	@echo "Building Linux executable..."
	@$(FLUTTER) build linux

clean:
	@echo "Cleaning up..."
	@$(FLUTTER) clean
