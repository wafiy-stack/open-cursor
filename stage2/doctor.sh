#!/bin/sh
# Static build gate only: no network, npm execution, or GitHub Actions dispatch.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
[ -d .git ] || fail 'Not a full git checkout.'
for f in .nvmrc LICENSE.txt ThirdPartyNotices.txt package.json product.json \
         scripts/open-cursor/package-mac.sh extensions/open-cursor/src/update/updater.ts \
         extensions/open-cursor/contrib/update.json install.sh install.ps1 \
         .github/workflows/wzb-open-cursor-macos-intel.yml stage2/UPSTREAM_SHA; do
  [ -s "$f" ] || fail "Required source file missing: $f"
done
[ "$(tr -d '\r\n' < .nvmrc)" = 24.18.0 ] || fail 'Node version mismatch.'
[ "$(tr -d '\r\n' < stage2/UPSTREAM_SHA)" = "aaca6ed1e687a55377226db1bca15f9f300865cc" ] || fail 'Provenance mismatch.'
grep -q 'REPO="wafiy-stack/open-cursor"' install.sh || fail 'Shell installer points outside the fork.'
grep -q "\$repo = 'wafiy-stack/open-cursor'" install.ps1 || fail 'Windows installer points outside the fork.'
grep -q 'api.github.com/repos/wafiy-stack/open-cursor/releases/latest' extensions/open-cursor/src/update/updater.ts || fail 'Updater points outside the fork.'
python3 - <<'PY'
import json
with open('extensions/open-cursor/contrib/update.json', encoding='utf8') as file:
    mode = json.load(file)['configuration']['properties']['openCursor.update.mode']['default']
if mode != 'off':
    raise SystemExit('Automatic update checks are not disabled by default')
PY
WF=.github/workflows/wzb-open-cursor-macos-intel.yml
grep -q 'workflow_dispatch:' "$WF" || fail 'Workflow has no manual dispatch trigger.'
grep -q 'runs-on: macos-15-intel' "$WF" || fail 'Wrong architecture runner.'
grep -q 'approve_compute == true' "$WF" || fail 'Explicit compute approval gate missing.'
grep -q 'contents: read' "$WF" || fail 'Workflow needs read-only contents.'
grep -q 'actions/upload-artifact@v4' "$WF" || fail 'No Actions artifact upload.'
if grep -E 'gh release (create|upload)|scripts/open-cursor/upload-draft.sh|contents: write|^  (push|schedule|release):' "$WF" >/dev/null; then
  fail 'Workflow has release publishing, excessive permissions, or automatic triggering.'
fi
printf 'PASS: source, upstream provenance, Intel runner, manual approval, update isolation and read-only release safeguards.\n'
git rev-parse --short HEAD
