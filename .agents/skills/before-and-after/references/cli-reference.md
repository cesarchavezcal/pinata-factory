# CLI Reference: before-and-after

Command line patterns, flags, upload adapters, Vercel protection bypass, and troubleshooting for `@vercel/before-and-after`.

> **Package note:** Always invoke as `@vercel/before-and-after` or use the global binary installed from that package. Never use the un-scoped `before-and-after` package name on npm.

---

## Command Patterns

```bash
# Basic capture between two URLs
before-and-after <before-url> <after-url>

# Scope capture to a specific CSS selector
before-and-after url1 url2 ".hero-section"

# Use different selectors for before and after states
before-and-after url1 url2 ".old-card" ".new-card"

# Responsive viewports
before-and-after url1 url2 --mobile    # 375x812
before-and-after url1 url2 --tablet    # 768x1024
before-and-after url1 url2 --full      # full scroll capture

# Compare existing local image files
before-and-after before.png after.png --markdown

# Execute via npx without global install
npx @vercel/before-and-after url1 url2
```

---

## CLI Flags

| Flag | Description | Default |
|---|---|---|
| `-m, --mobile` | Mobile viewport (375x812) | Off |
| `-t, --tablet` | Tablet viewport (768x1024) | Off |
| `--size <WxH>` | Custom viewport dimensions | Desktop default |
| `-f, --full` | Capture full scrollable page | Off |
| `-s, --selector` | CSS selector to capture | Entire viewport |
| `-o, --output` | Output directory | `~/Downloads` |
| `--markdown` | Upload images and output markdown comparison table | Off |
| `--upload-url <url>` | Custom upload endpoint | `0x0.st` |

---

## Image Upload Adapters

Use `./scripts/upload-and-copy.sh` to host capture pairs and format markdown for PRs:

```bash
# Default adapter (0x0.st - no authentication needed)
./scripts/upload-and-copy.sh before.png after.png --markdown

# GitHub Gist adapter (requires gh auth)
IMAGE_ADAPTER=gist ./scripts/upload-and-copy.sh before.png after.png --markdown
```

---

## Vercel Deployment Protection

When capturing preview deployments (`*.vercel.app`) returning HTTP 401 or 403:

1. **Verify Vercel CLI session:**
   ```bash
   which vercel && vercel whoami
   ```
2. **Retrieve bypass token:**
   ```bash
   vercel inspect <url>
   ```
   Extract the protection bypass header or token from the inspect output.
3. **Fallback:** If CLI credentials are unavailable, ask user for a bypass secret or use an unauthenticated deployment URL.

---

## PR Integration

Automate attaching before-and-after visual evidence to GitHub pull requests:

```bash
# 1. Verify GitHub CLI authentication
which gh && gh auth status

# 2. Fetch current PR description
gh pr view --json number,body

# 3. Append screenshot table to PR description
gh pr edit <number> --body "$(gh pr view <number> --json body -q .body)

## Before and After
<generated-markdown-table>"
```

If `gh` CLI is absent, emit the markdown table directly to standard output for manual pasting.

---

## Error Recovery

| Error | Root Cause | Fix |
|---|---|---|
| `command not found` | Package not installed globally | `npm install -g @vercel/before-and-after` |
| `could not determine executable` | NPX package ambiguity | Use `npx @vercel/before-and-after` explicitly |
| `401 / 403 Forbidden` | Vercel Deployment Protection | Run `vercel inspect <url>` or request bypass token |
| `Element not found` | Selector missing on target page | Verify CSS selector exists in both DOMs |
