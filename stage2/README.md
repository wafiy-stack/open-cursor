# Stage 2 — macOS Intel evaluation build (wafiy-stack)

This repository is a full GitHub fork of [noah-thing/open-cursor](https://github.com/noah-thing/open-cursor), preserved at upstream commit `aaca6ed1e687a55377226db1bca15f9f300865cc`. This branch adds an **opt-in** Intel Mac build workflow without publishing a release.

## Scope
- Platform: 2018 Intel Mac mini, macOS x64 / x86_64 DMG.
- Full source, MIT license and third-party notices remain in the repository history.
- Updates and installers are scoped to `wafiy-stack/open-cursor`, and automatic updates default to off.
- The upstream release workflow is unchanged, but must not be triggered without your explicit approval.

## Review first
1. Review this branch as a **draft PR**. Check `stage2/RELEASE_GATES.md`.
2. Inspect the workflow YAML, source URL changes, and `stage2/doctor.sh`.
3. Do not merge or trigger GitHub Actions before authorizing the next stage.

## When you later approve a build
1. Review and merge the PR after code review.
2. Check GitHub Actions usage/billing for the `wafiy-stack` account.
3. Go to Actions → **OpenCursor / macOS Intel test DMG** → **Run workflow**.
4. Select `approve_compute` only after reviewing potential compute usage.
5. If the job succeeds, download the `opencursor-macos-intel-test-dmg` Actions artifact and verify `SHA256SUMS.txt`.
6. Test it on your 2018 Intel Mac mini. This is an evaluation build, not a signed/notarized production release.

## Local static checks
```sh
sh stage2/doctor.sh
```

No automated jobs, paid infrastructure or releases are created merely by opening this pull request.
