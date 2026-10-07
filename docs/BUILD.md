# Building Ghost Browser

## Requirements

Use a supported Linux/WSL2 build environment with Git, Python 3, Node.js, pnpm/Corepack, Android build dependencies, and enough disk/RAM for Chromium. The Brave Android documentation currently calls for Git 2.41+, Python 3, Node.js 24+, and Android build dependencies on supported Ubuntu/Debian environments.

## First setup

```bash
./scripts/verify-logo.sh
./scripts/bootstrap.sh
```

Initialization downloads Chromium and can be very large.

## Debug APK

```bash
./scripts/build-debug-apk.sh
```

The build is intentionally an actual Brave/Chromium Android build rather than an Android WebView wrapper.

## Release APK

```bash
./scripts/build-release-apk.sh
```

Release signing credentials are not committed to the repository. A personal keystore/signing setup will be added before public release builds.
