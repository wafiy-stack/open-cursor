# Stage 2: release and compute safeguards

**This is an evaluation build of a desktop app, not a web deployment.** This branch does not create a release, tag, paid hosting service, or Actions run.

## Source and identity
- Full upstream source is inherited through GitHub fork history from noah-thing/open-cursor, commit `aaca6ed1e687a55377226db1bca15f9f300865cc` (v0.1.10).
- Original MIT license, copyright attribution, and ThirdPartyNotices are preserved.
- Build target: 2018 Intel Mac mini, macOS x86_64; Node from `.nvmrc` (24.18.0).
- No full rebrand yet. App bundle identifier and data directory may conflict with upstream if both versions are installed.

## Build policy
- `.github/workflows/wzb-open-cursor-macos-intel.yml` triggers **only** with manual `workflow_dispatch`.
- Job skips unless `approve_compute` is actively selected. This is an explicit billing-consent control, not a billing guarantee.
- Uses standard `macos-15-intel` hosted runner; repository token has `contents: read`.
- Uploads a three-day GitHub Actions test artifact plus SHA-256 checksum; **no public GitHub release** is created.
- Do not run the upstream `.github/workflows/release.yml` without separate release approval: that existing workflow can attach assets to a release.
- The new workflow is intended to be reviewed and merged before its first manual Actions run. Verify account-specific GitHub Actions billing limits before dispatching.

## Update safety
- Fork update feed and local install scripts point at `wafiy-stack/open-cursor`, not upstream release binaries.
- Automatic background update checks default to `off`; existing saved settings may override this default.
- There is intentionally **no fork release yet**; fork install scripts will fail rather than install an unrelated upstream build.
- Signed upstream notices from `opencursor.org` are still present. Audit or disable notices in a separately reviewed branding/privacy stage.

## Required before public release
1. Review this draft PR and validate static checks; only merge with your approval.
2. Approve compute, dispatch the manual workflow, inspect logs and download the evaluation DMG.
3. Verify DMG SHA-256, x86_64 architecture and code signature; test installation on the Intel Mac mini.
4. Review upstream supply chain, credentials, MCP/agent command permissions, telemetry, and updates.
5. Decide branding, distinct bundle identifier, Windows GUIDs, support and privacy URLs.
6. Sign and notarize macOS installer with credentials you control for ordinary distribution.
7. Test update/rollback and uninstall flows, and build/test other platforms if needed.

**Status:** GitHub fork exists. This branch is a build/test preparation only. No Actions run or installer has been produced by these changes.
