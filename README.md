# TV-VibeOS

Debloat my Roku OS (TCL 55R615) and Android TVs.

Roku OS can't be replaced, and developer mode can only sideload Roku channels. So this repo ships
**VibeOS Launcher**: an ad-free, tile-based channel that opens your streaming apps directly.
It does not replace the Roku home screen; you open it from the Roku home (or via the dev-mode launch).

## What's here
- `roku-channel/` - the channel (BrightScript + SceneGraph, 1080p UI)
  - `config/channels.json` - tiles, app IDs and colors. Edit this to add/remove/reorder apps.
- `tools/build.sh` - builds `build/vibeos-launcher.zip`
- `tools/deploy.sh <roku_ip> <dev_password>` - build + upload from a computer on your Wi-Fi
- `tools/list_apps.sh <roku_ip>` - list installed channel IDs (to fill in missing IDs)

Default tiles: Netflix, Prime Video, HBO Max, Apple TV, Hulu, Peacock, Stremio.
Stremio has no official Roku app ID, so its tile shows a hint until you set one.

## Install (sideload)
1. Build the zip: `./tools/build.sh` (or download `vibeos-launcher.zip` from wherever you built it).
   Get the zip onto your phone if you'll use the phone browser.
2. Open `http://<tv-ip>` (yours: `http://10.0.0.33`), sign in as `rokudev` with the dev password
   you set when enabling developer mode.
3. Tap **Upload**, choose `vibeos-launcher.zip`, then **Install with zip**.
   Don't use "Install with squashfs"; that's for a different package format.
4. The channel launches immediately and stays on the Roku home screen as "VibeOS Launcher".

### If the install fails
- **Login prompt won't accept anything**: the username is `rokudev`; the password is the one you
  chose in developer mode setup. To reset it, repeat the Home x3, Up x2, Right, Left, Right, Left,
  Right key sequence.
- **Upload button does nothing on phone**: try desktop mode in Chrome, or use `tools/deploy.sh`.
- **"Install Failure: Compilation Failed"**: the page prints the error; send it to me.
- **Tile says "ECP returned 403/0"**: on the TV go to Settings > System > Advanced system settings >
  Control by mobile apps > Network access, and set it to **Default** (or Permissive).

## How launching works
Selecting a tile POSTs to the TV's own ECP endpoint (`http://<tv-ip>:8060/launch/<appId>`) from
inside the channel. Common IDs: Netflix 12, Prime Video 13, Hulu 2285, Apple TV 551012,
Peacock 593099, HBO Max 61322. IDs can change; verify with `tools/list_apps.sh 10.0.0.33`.

## Notes
- Developer-mode channels are for you only; they survive reboots but not a factory reset.
- Untested on real hardware as of this commit (the code lint-checks clean with BrighterScript).
  Expect some tweaking on first run.
- The Android TV approach from tv-vibehack applies only if you add an Android/Google TV box.
