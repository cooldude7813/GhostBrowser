# Ghost Browser architecture

## Layers

### 1. Chromium / Brave engine
Provides page rendering, JavaScript, networking, storage, cookies, GPU acceleration, security primitives, downloads, permissions, and the browser process architecture.

### 2. Ghost browser layer
Owns Ghost-specific behavior and the stable interface between the UI and the engine:

- navigation
- tabs and tab groups
- history
- bookmarks
- downloads
- private browsing
- permissions
- search/address handling
- privacy controls
- GhostOS integration

### 3. Ghost UI
The target UI combines Opera's customization/navigation ideas with Brave's privacy-focused browser experience. The UI is being built as production browser UI, not a throwaway mockup.

Target surfaces include:

- Ghost new-tab/home screen
- omnibox/address/search bar
- tab manager
- private mode
- downloads
- bookmarks/history
- settings
- privacy dashboard
- bottom navigation
- adaptive phone/foldable/tablet layouts

### 4. GhostOS integration
Later, the same browser layer will expose GhostOS-specific APIs for default-browser selection, system sharing, account/sync integration, battery/data controls, and app-store updates.

## Source strategy

The Brave/Chromium source tree is intentionally fetched during bootstrap instead of copied into this repository. Chromium has a very large history and Brave's documented initialization process downloads it into the build workspace.
