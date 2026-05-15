APP_NAME = CalendarApp
APP_BUNDLE = $(APP_NAME).app

.PHONY: build run test clean

build:
	swift build -c release 2>&1
	sh scripts/package_app.sh

run: build
	open $(APP_BUNDLE)

test:
	sh scripts/test_models.sh

clean:
	rm -rf .build $(APP_BUNDLE)
