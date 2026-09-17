# Recorder Guide: evidence-driven-testing

Architecture, OS capture matrix, supervisor lifecycles, and `cua-driver` integration for `scripts/evidence.py`.

---

## Toolchain Verification

Run pre-flight check before initiating test runs:

```bash
python3 scripts/evidence.py doctor
```

The doctor command verifies:
- `ffmpeg` and `ffprobe` binaries on `PATH`
- `libx264` codec availability
- `ass` subtitle/annotation filter support
- Platform screen capture device status (`capture_ready`)

---

## OS Screen Capture Matrix

| Operating System | Capture Source | Requirements & Considerations |
|---|---|---|
| **Linux X11 / XWayland** | `x11` (`x11grab`) | Requires `DISPLAY` environment variable. Full screen capture by default; `--geometry WxH` and `--offset X,Y` crop target region. |
| **Linux Wayland** | `wayland` (`wf-recorder`) | Requires `WAYLAND_DISPLAY` and `wf-recorder` on `PATH`. Compositor must support `wlr-screencopy` (Sway, Hyprland, river, Wayfire, labwc, dwl, niri). GNOME/KDE Wayland cannot be captured via wf-recorder; use XWayland (`x11`) or fallback recorder. |
| **macOS** | `avfoundation` | Requires Screen Recording permission granted to host terminal application. Use `doctor` to list screen indexes for `--screen-index`. |
| **Windows** | `gdigrab` | Any standard FFmpeg build. PowerShell used for process management. |

---

## Supervisor Process Architecture

To prevent video file corruption and dangling processes:
1. **Raw Container:** Video captures directly to MPEG-TS (`raw.ts`). If the process terminates abruptly, existing frames probe and render cleanly.
2. **Process Management:**
   - **Linux:** Signaling performed via `pidfd`.
   - **macOS / Windows:** `start` spawns a background supervisor process that owns the FFmpeg child. `stop` writes `stop.request` to the session directory, escalating from SIGINT to SIGTERM to SIGKILL, then writes `recorder-exit.json`.
3. **Failure States:**
   - `finalization_failed`: Rendering or filter graph error. Fix reported issue and rerun `stop` (will not signal child twice).
   - `recorder_lost`: Supervisor terminated or PID was recycled. Verify child process is dead before finalizing with `--accept-untracked-recorder`.

---

## Fallback Recorders

If `scripts/evidence.py doctor` reports no capture source:

1. **macOS Native Fallback:**
   ```bash
   screencapture -v .artifacts/<task>/out.mov
   ```
2. **CUA Driver GUI Fallback (`cua-driver`):**
   When GUI exists but built-in computer-use tools are absent:
   - Verify environment: `cua-driver doctor`
   - Launch daemon: `cua-driver serve`
   - Record session: `cua-driver recording start .artifacts/<task>` / `cua-driver recording stop`
   - Follow interaction loop: `launch_app` -> `get_window_state` -> act via `element_token` -> `verify_state`.
   - Each `verify_state` maps 1:1 to an assertion. If FFmpeg is missing on Windows/Linux, verify trajectory folder captures.
   - Maintain `assertions.md` listing each test and assertion result.
