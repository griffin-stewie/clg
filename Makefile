BINARIES_FOLDER=/usr/local/bin
EXECUTABLE=$(shell swift build --configuration release --show-bin-path)/clg

.PHONY: build install clean

build:
	swift build -c release

install: clean build
	install -d "$(BINARIES_FOLDER)"
	install "$(EXECUTABLE)" "$(BINARIES_FOLDER)"

clean:
	swift package clean