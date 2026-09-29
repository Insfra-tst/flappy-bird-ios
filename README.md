# Flappy Bird iOS game

This is a tiny native SpriteKit game with no external assets or dependencies.

## Build without opening Xcode

You still need Apple’s iOS SDK and signing services somewhere. The build itself can be completely command-line driven; Apple’s Command Line Tools alone do not include the iOS SDK.

### Option A: build on a Mac with Xcode installed

1. Install Xcode from the Mac App Store once, open it once to accept the license, and install an iOS platform if prompted.
2. Create or use an Apple Developer team and obtain its Team ID.
3. From this folder run:

```sh
chmod +x build-ipa.sh
TEAM_ID=YOUR_TEAM_ID ./build-ipa.sh
```

The IPA will be at `build/export/FlappyBird.ipa`.

If you want Sideloadly or AltStore to perform the final signing, build an unsigned IPA instead:

```sh
chmod +x build-unsigned-ipa.sh
./build-unsigned-ipa.sh
```

Use `build-unsigned/FlappyBird-unsigned.ipa` in Sideloadly. This still requires a Mac build environment with the iOS SDK, but does not require you to manage a signing certificate during the build.

### Option B: build in GitHub Actions (no local Xcode UI)

Push this folder to a GitHub repository. The included workflow builds an unsigned IPA on a hosted macOS runner and uploads it as a workflow artifact. No signing secrets are required; Sideloadly or AltStore signs the IPA when you install it.

## Install by sideloading

For a free Apple ID / development signing:

1. Install AltStore on your iPhone using AltServer, or install Sideloadly on your computer.
2. Connect the iPhone, trust the computer, and enable Developer Mode if iOS asks.
3. In AltStore choose `+` and select `FlappyBird.ipa`, or drag the IPA into Sideloadly.
4. Sign in with the Apple ID used for signing and install.

Free Apple ID signing normally expires after 7 days. A paid Apple Developer account generally allows longer-lived development provisioning. The iPhone must trust the developer profile under Settings → General → VPN & Device Management.

## Controls

Tap anywhere to flap. Tap after game over to restart.
