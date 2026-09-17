---
name: before-and-after
description: "Trigger: take before and after, screenshot comparison, or PR screenshots. Captures and compares web UI states or image files."
license: MIT
metadata:
  author: michaelshimeles
  version: "2.0"
---

# Before and After

Capture side-by-side screenshots of web interfaces or image files for visual regression and PR documentation.

## Activation Contract

- **Trigger:** User asks to "take before and after", "screenshot comparison", "visual diff", "PR screenshots", "compare old and new", or needs visual UI verification.
- **Inputs:** Two URLs (`http://`, `https://`, `file://`) or two image paths. If only one URL is provided, prompt user for the "before" state URL.

## Hard Rules

- Always use package `@vercel/before-and-after` (never un-scoped `before-and-after`).
- Never switch git branches, stash uncommitted work, or launch dev servers.
- Never pass `--full` unless user explicitly requests full scroll capture.
- Assume current local state represents "After".
- Never skip pre-flight binary check or Vercel protection status check.

## Decision Gates

| Condition | Action | Next Step |
|---|---|---|
| Binary missing | Run `npm install -g @vercel/before-and-after` | Retry capture |
| Target is `.vercel.app` (401/403) | Run `vercel inspect <url>` to retrieve bypass token | Inject bypass header |
| User specifies mobile/tablet | Add `--mobile` (375x812) or `--tablet` (768x1024) | Execute capture |
| Only 1 URL supplied | Halt and ask for "before" baseline URL | Await user input |
| PR integration requested | Run `./scripts/upload-and-copy.sh` with `--markdown` | Append via `gh pr edit` |

## Execution Steps

1. Verify CLI installation: `which before-and-after || npm install -g @vercel/before-and-after`.
2. Check for Vercel deployment protection if URL matches `*.vercel.app`: `curl -s -o /dev/null -w "%{http_code}" "<url>"`.
3. Capture comparison: `before-and-after "<before-url>" "<after-url>"`.
4. Upload capture pair to generate markdown: `./scripts/upload-and-copy.sh <before.png> <after.png> --markdown`.
5. Post to pull request if `gh` CLI is authenticated: `gh pr edit <pr-number> --body "<body-with-markdown>"`.

## Output Contract

- Dual image artifacts (`before.png` and `after.png`) or hosted image URLs.
- Markdown side-by-side comparison table for PR inclusion.
- Terminal confirmation of PR update or generated markdown snippet.

## References

- [CLI Reference](references/cli-reference.md): Command flags, Vercel bypass workflow, upload adapters, and error recovery.
