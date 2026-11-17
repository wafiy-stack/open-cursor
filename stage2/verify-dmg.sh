#!/bin/sh
# Validate the built Intel DMG in a read-only mount, without launching or installing it.
set -eu
[ "$(uname -s)" = Darwin ] || { echo 'macOS required for DMG verification.' >&2; exit 1; }
[ "$#" -eq 1 ] || { echo 'Usage: sh stage2/verify-dmg.sh /path/to/OpenCursor.dmg' >&2; exit 1; }
DMG=$1
[ -s "$DMG" ] || { echo "Missing DMG: $DMG" >&2; exit 1; }
STAGE=$(mktemp -d)
MOUNT="$STAGE/mounted"
mkdir -p "$MOUNT"
cleanup() {
  if [ "${ATTACHED:-}" = YES ]; then hdiutil detach -quiet "$MOUNT" >/dev/null 2>&1 || true; fi
  rm -rf "$STAGE"
}
trap cleanup EXIT HUP INT TERM
hdiutil attach -readonly -nobrowse -noautoopen -mountpoint "$MOUNT" "$DMG" >/dev/null
ATTACHED=YES
APP="$MOUNT/OpenCursor.app"
[ -d "$APP" ] || { echo 'DMG missing OpenCursor.app' >&2; exit 1; }
[ -f "$APP/Contents/Info.plist" ] || { echo 'DMG missing Info.plist' >&2; exit 1; }
[ -x "$APP/Contents/MacOS/OpenCursor" ] || { echo 'DMG missing executable' >&2; exit 1; }
/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP/Contents/Info.plist"
ARCH=$(lipo -archs "$APP/Contents/MacOS/OpenCursor")
printf 'Executable architectures: %s\n' "$ARCH"
printf '%s\n' "$ARCH" | grep -Eq '(^| )x86_64( |$)' || { echo 'Not compatible with Intel macOS.' >&2; exit 1; }
codesign --verify --deep --strict --verbose=2 "$APP"
echo 'PASS: Intel DMG structure, architecture and local code signature.'
