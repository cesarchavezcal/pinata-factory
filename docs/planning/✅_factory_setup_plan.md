# Implementation Plan: Software Factory Setup via AGENTS.md & README.md

This plan clarifies why `AGENTS.md` and `README.md` are distinct standards, explains the strict planning boundary pause, and details how both files will be created upon approval.

---

## 1. Goal Description

Establish the complete **Software Factory** documentation and governance files in `pinata-factory`:
1. **`AGENTS.md`**: The runtime instruction contract for AI agents (Claude Code, Cursor, Antigravity) defining the 4-Beat workflow (`/new-feature` → `/code-structure` → `/evidence-driven-testing` → `/before-and-after` + `/greploop`).
2. **`README.md`**: The human-facing repository documentation explaining the purpose of `pinata-factory`, how to use it, and how the factory operates.

---

## 2. Why `AGENTS.md` and Not `AGENTS.readme`?

### Standard Naming Conventions
- **Harness Auto-Discovery**: Agent harnesses specifically scan for `AGENTS.md` (or `CLAUDE.md`). Non-standard names like `AGENTS.readme` or `AGENTS.txt` are **ignored** by agent runtimes and will fail to load automatically.
- **Audience Separation**:
  - `README.md` is written for **humans** (developers, visitors, contributors).
  - `AGENTS.md` is written for **LLMs** (imperative execution rules, boundary constraints, zero fluff).

### Why It Wasn't Created in the Previous Turn
Under strict `/plan` protocol, the agent is **hard-blocked** from creating project code or modifying files during a planning pass. The agent must first present the technical plan, wait for explicit user approval, and execute the writes in the follow-up execution turn.

---

## 3. Proposed Changes

### Documentation & Contract Layer

#### `[NEW]` [AGENTS.md](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/AGENTS.md)
The authoritative agent runtime instructions based on `michaelshimeles/skills`:
- 4-Beat workflow instructions.
- Ship-beat notes (flags, sandbox bypasses, upload hosts).
- Writing for humans rules enforced via `/unslop`.
- Multi-agent rules (scope checks, worktree boundaries, `--force-with-lease`).
- 8-step task completion checklist.
- Local skill mapping pointing to [`.agents/skills/`](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/.agents/skills).

#### `[NEW]` [README.md](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/README.md)
Human-facing project documentation:
- What `pinata-factory` is.
- Quick start guide.
- Explanation of the 4-Beat Factory flow.
- Link to `AGENTS.md` for agent governance.

#### `[MODIFY]` [.gitignore](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/.gitignore)
Protect scratch files and worktree directories:
```gitignore
# Worktrees
.worktrees/

# Evidence captures & recordings
.artifacts/
*.mp4
*.ts
raw.ts
frame.png

# Local AI runtime state
.atl/
```

---

### Factory Toolchain

#### `[NEW]` [scripts/factory-doctor.sh](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/scripts/factory-doctor.sh)
Health-check script validating local prerequisites (`git`, `gh`, `@vercel/before-and-after`, Python 3, `ffmpeg`).

---

## 4. Verification Plan

1. **Check files:** Verify both `AGENTS.md` and `README.md` are present at the repo root.
2. **Check auto-discovery:** Run `gentle-ai skill-registry refresh` to confirm skill indexing.
3. **Run Doctor:** Execute `scripts/factory-doctor.sh` to ensure tooling readiness.
