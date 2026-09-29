#!/bin/zsh
set -euo pipefail

ROOT="${0:A:h}"
PROJECT="$ROOT/FlappyBird.xcodeproj"
BUILD_DIR="$ROOT/build"
ARCHIVE="$BUILD_DIR/FlappyBird.xcarchive"
EXPORT="$BUILD_DIR/export"

: "${TEAM_ID:?Set TEAM_ID to your Apple Developer Team ID}"
: "${SIGNING_IDENTITY:=Apple Development}"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

xcodebuild -project "$PROJECT" -scheme FlappyBird -configuration Release \
  -sdk iphoneos -archivePath "$ARCHIVE" \
  DEVELOPMENT_TEAM="$TEAM_ID" CODE_SIGN_STYLE=Automatic \
  CODE_SIGN_IDENTITY="$SIGNING_IDENTITY" archive

cat > "$BUILD_DIR/ExportOptions.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>method</key><string>development</string>
<key>signingStyle</key><string>automatic</string>
<key>teamID</key><string>$TEAM_ID</string>
</dict></plist>
PLIST

xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$EXPORT" \
  -exportOptionsPlist "$BUILD_DIR/ExportOptions.plist"

echo "IPA: $EXPORT/FlappyBird.ipa"
