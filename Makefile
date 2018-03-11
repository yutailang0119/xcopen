PREFIX?=/usr/local

build:
	swift build -c release -Xswiftc -static-stdlib

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/xcopen" "$(PREFIX)/bin/xcopen"

generate_xcodeproj:
	swift package generate-xcodeproj
