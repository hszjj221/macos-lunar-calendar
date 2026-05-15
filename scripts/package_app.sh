#!/bin/sh
set -eu

APP_NAME="${APP_NAME:-CalendarApp}"
CONFIGURATION="${CONFIGURATION:-release}"
BUILD_DIR="${BUILD_DIR:-.build/$CONFIGURATION}"
APP_BUNDLE="${APP_BUNDLE:-$APP_NAME.app}"
INFO_PLIST="${INFO_PLIST:-Sources/CalendarApp/Resources/Info.plist}"
EXECUTABLE="$BUILD_DIR/$APP_NAME"

if [ ! -x "$EXECUTABLE" ]; then
    echo "Missing executable: $EXECUTABLE" >&2
    echo "Run 'swift build -c $CONFIGURATION' first." >&2
    exit 1
fi

mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"
cp "$EXECUTABLE" "$APP_BUNDLE/Contents/MacOS/"
cp "$INFO_PLIST" "$APP_BUNDLE/Contents/"
