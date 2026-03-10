APP_NAME = CalendarApp
BUILD_DIR = .build/release
APP_BUNDLE = $(APP_NAME).app

.PHONY: build run clean

build:
	swift build -c release 2>&1
	mkdir -p $(APP_BUNDLE)/Contents/MacOS
	mkdir -p $(APP_BUNDLE)/Contents/Resources
	cp $(BUILD_DIR)/$(APP_NAME) $(APP_BUNDLE)/Contents/MacOS/
	cp Sources/CalendarApp/Resources/Info.plist $(APP_BUNDLE)/Contents/

run: build
	open $(APP_BUNDLE)

clean:
	rm -rf .build $(APP_BUNDLE)
