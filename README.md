# Ghost Browser

Ghost Browser is a real Android browser project built on the open-source Brave/Chromium browser foundation, with Ghost's own branding, UI, privacy configuration, and GhostOS integration planned on top.

This repository does **not** vendor Chromium or Brave's enormous source tree. The bootstrap process fetches the pinned Brave/Chromium source into the local `src/` workspace, keeping the project manageable while preserving a reproducible foundation.

## Build strategy

1. Fetch Brave Core and initialize Chromium for Android.
2. Apply the Ghost Browser branding layer.
3. Build the real Brave/Chromium Android browser as an APK.
4. Replace/extend the browser UI with the Ghost UI in incremental, production-oriented changes.
5. Run Android/browser tests after each major change.

Brave's current public Android build instructions use `pnpm run init --target_os=android --target_arch=arm` and `pnpm run build --target_os=android --target_arch=arm`; debug APK output can be requested with `--target_android_output_format=apk`.

## Branding rule

The supplied Ghost Browser logo in `branding/ghost-browser-logo.png` is the canonical app logo. Every Ghost Browser build must use Ghost branding rather than Brave branding in user-facing app identity.

## Licensing

Brave/Chromium components remain subject to their respective open-source licenses and notices. Ghost Browser branding and original Ghost code are separate. We will not copy proprietary Brave assets or trademarks.
