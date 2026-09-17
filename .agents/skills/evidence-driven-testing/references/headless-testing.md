# Headless Testing Guide: evidence-driven-testing

Scripted browser capture, file-based assertions, and non-UI evidence patterns.

---

## Headless Browser Capture

When running in headless environments (no physical display or GUI desktop):

1. Store all output in a gitignored task directory: `.artifacts/<task-name>/`.
2. **Element & URL Snapshots:**
   Use `@vercel/before-and-after` for static visual comparisons:
   ```bash
   AGENT_BROWSER_ARGS="--no-sandbox" npx @vercel/before-and-after <url1> <url2> --markdown
   ```
3. **Interactive Multi-Step Flows (Playwright):**
   Run an isolated, one-off Playwright script without modifying repository dependencies:
   ```bash
   npx --yes --package=playwright node record.mjs
   ```

### Minimal `record.mjs` Implementation

```javascript
import { chromium } from "playwright";

const browser = await chromium.launch({
  args: ["--no-sandbox", "--disable-setuid-sandbox"]
});

const context = await browser.newContext({
  recordVideo: {
    dir: ".artifacts/user-profile-test/",
    size: { width: 1280, height: 720 }
  }
});

const page = await context.newPage();
await page.goto("http://localhost:3000/profile");

// Perform test actions
await page.fill("#name-input", "Alice Smith");
await page.click("#save-button");
await page.waitForSelector(".success-toast");

// Finalize recording
await context.close();
await browser.close();
```

---

## File-Based Annotation Protocol

When video overlay burning is unavailable:

1. **Sequential Naming:** Save screenshots named by step and assertion outcome:
   - `01-precondition-login-page.png`
   - `02-navigate-to-settings-passed.png`
   - `03-update-display-name-passed.png`
2. **Assertions Manifest (`assertions.md`):**
   ```markdown
   # Assertions Log

   - **Test 1:** User profile updates
     - [PASS] Precondition: User authenticated as admin (01-precondition-login-page.png)
     - [PASS] Form submits without validation error (02-navigate-to-settings-passed.png)
     - [PASS] Toast indicates changes saved (03-update-display-name-passed.png)
   ```

---

## Non-UI Evidence Patterns

- **API & Performance:** Record benchmark numbers (request latency, p95/p99, throughput) to `probe-output.txt`.
- **Canvas / Shader / Graphics:** Export rendered frame PNGs and compute pixel diff deltas.
- **Agent Behavior:** Extract exact transcript turns showing tool invocation and verified response.
- **Bug Fixes:** Always capture reproduction of failure prior to applying fix as "before" evidence.

---

## Port and Listener Verification

Ensure target services correspond to current branch code:

```bash
# macOS / BSD
lsof -i :<port>

# Linux
ss -ltnp "sport = :<port>"

# Verify process invocation
ps -p <PID> -o args=
```
