#!/bin/zsh
set -euo pipefail

ROOT="${0:A:h}"
BUILD_DIR="$ROOT/build-unsigned"
APP_DIR="$BUILD_DIR/Products/Applications/FlappyBird.app"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/Products/Applications"

xcodebuild -project "$ROOT/FlappyBird.xcodeproj" -scheme FlappyBird -configuration Release \
  -sdk iphoneos -derivedDataPath "$BUILD_DIR/DerivedData" \
  CONFIGURATION_BUILD_DIR="$BUILD_DIR/Products/Applications" \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build

mkdir -p "$BUILD_DIR/Payload"
mv "$APP_DIR" "$BUILD_DIR/Payload/FlappyBird.app"
(cd "$BUILD_DIR" && /usr/bin/zip -qry FlappyBird-unsigned.ipa Payload)
echo "IPA: $BUILD_DIR/FlappyBird-unsigned.ipa"
