---
name: evidence-driven-testing
description: "Trigger: prove UI behavior, verify change, or generate test evidence. Records visual or scripted proof with assertions for PRs."
license: MIT
metadata:
  author: michaelshimeles
  version: "2.0"
---

# Evidence-Driven Testing

Record annotated visual or scripted proof of application behavior, attaching verified artifacts to PRs and tracker issues.

## Activation Contract

- **Trigger:** User requires verifiable proof that changes work, UI visual testing, regression reproduction, or PR demonstration.
- **Modes:** GUI with computer use, GUI via `cua-driver`, Headless browser (Playwright), or non-UI backend probes.

## Hard Rules

- Video must record live, interactive execution; never present scripted replays, stitched clips, or synthetic footage as UI recordings.
- Never record an obscured or half-tiled window; maximize target window before capture.
- Never record sensitive data, API tokens, customer PII, or payment info; mark affected steps `untested`.
- Assertion messages must stay under 80 characters.
- Every recording must be tagged with exact git commit SHA and branch.

## Decision Gates

| Environment | Primary Tool | Evidence Artifact |
|---|---|---|
| GUI + Computer Use | `scripts/evidence.py` | `evidence.mp4` with burned-in assertion overlays |
| GUI without Computer Use | `cua-driver` + `evidence.py` | `evidence.mp4` or trajectory captures |
| Headless / No Display | Playwright (`record.mjs`) | `.webm` video / PNG frames + `assertions.md` |
| Non-UI / Backend | Scripted probe / benchmark | `probe-output.txt` with before/after metric deltas |

## Execution Steps

1. Run toolchain pre-flight: `python3 scripts/evidence.py doctor`.
2. Prepare display: maximize target window and record current revision (`git rev-parse HEAD`).
3. Start session: `python3 scripts/evidence.py start --output .artifacts/<task> --commit "$(git rev-parse HEAD)"`.
4. Add setup annotation: `python3 scripts/evidence.py annotate "$SESSION" --type setup --message "<context>"`.
5. Execute live interaction: annotate each `test_start` and record `assertion` (`--result passed|failed|untested`).
6. Stop capture: `python3 scripts/evidence.py stop "$SESSION"` to compile `evidence.mp4` and `report.md`.
7. Extract validation frame (`ffmpeg -ss <t> -i evidence.mp4 -frames:v 1 frame.png`) and attach proof to PR.

## Output Contract

- Directory `.artifacts/<task-name>/` containing:
  - `evidence.mp4` (burned-in annotations)
  - `report.md` (environment, commit SHA, assertion table, completed caveats)
  - `manifest.json` (machine-readable run metadata)
- Verified PR comment with attached or linked video evidence.

## References

- [Recorder Guide](references/recorder-guide.md): OS screen capture matrix, supervisor architecture, and `cua-driver` integration.
- [Headless Testing](references/headless-testing.md): Playwright scripts, non-UI probes, and file-based assertion protocol.
