PREFIX?=/usr/local
VERSION=$(shell /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" XCOpen.xcodeproj/XCOpenKit_Info.plist)

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/xcopen" "$(PREFIX)/bin/xcopen"

clean:
	swift package clean

set_version:
	agvtool new-marketing-version ${VERSION}
	sed -i '' -e 's/current = ".*"/current = "${VERSION}"/g' Sources/XCOpenKit/Version.swift

generate_xcodeproj:
	swift package generate-xcodeproj
