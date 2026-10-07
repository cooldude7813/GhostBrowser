# Ghost Browser Android Build Environment

Ghost Browser uses the real Brave/Chromium Android foundation, so its build environment is much heavier than a normal Android/Gradle application.

## Required toolchain

- Linux/Ubuntu or WSL2/Codespaces
- Git
- Python 3
- Node.js 24+
- pnpm
- JDK 17 for the Ghost Browser development environment
- Android SDK/platform tools
- Chromium Android native build dependencies
- Enough disk and RAM for Chromium source and compilation

## Setup

From the repository root:

    ./scripts/setup-build-environment.sh

If the Brave source has not been fetched yet:

    ./scripts/bootstrap.sh
    ./scripts/setup-build-environment.sh

Bootstrap fetches Brave Core and initializes its Chromium checkout. Environment setup then installs JavaScript dependencies and synchronizes the Android Chromium source.

## CI

GitHub Actions includes a manual Ghost Browser Android Build Environment workflow. It verifies JDK 17, Node.js 24, pnpm, Python, Git, Android tooling, Chromium build dependencies, and Ghost branding.

This environment workflow does not claim that an APK exists. APK compilation remains a separate step after the real Brave/Chromium source synchronization succeeds.

This is the FemScroll-style build workflow adapted to Chromium/Brave rather than copying FemScroll's Gradle project.
