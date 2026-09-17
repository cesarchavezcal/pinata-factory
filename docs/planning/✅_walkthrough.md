# Walkthrough: Software Factory Setup in Pinata Factory

We have completed the setup of the **Software Factory** in `pinata-factory` based on the upstream [`AGENTS.md`](https://github.com/michaelshimeles/skills/blob/main/AGENTS.md) guide and the 7 local skills.

---

## What Was Accomplished

1. **Agent Governance Contract ([`AGENTS.md`](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/AGENTS.md))**:
   - Encoded the Four-Beat workflow (`/new-feature` → `/code-structure` → `/evidence-driven-testing` → `/before-and-after` + `/greploop`).
   - Defined multi-agent isolation rules (fresh worktrees, branch prefixes, scope checking via `gh pr list`).
   - Integrated human prose refinement rules via `/unslop`.
   - Mapped all 7 skills directly to local `.agents/skills/`.

2. **Human Documentation ([`README.md`](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/README.md))**:
   - Clear architectural overview of the factory beats.
   - Quickstart guide and skill listing.
   - Cross-link to `AGENTS.md` for AI agent governance.

3. **Repository Hygiene ([`.gitignore`](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/.gitignore))**:
   - Excluded `.worktrees/`, `.artifacts/`, video captures (`*.mp4`, `*.ts`), and local runtime state (`.atl/`).

4. **Toolchain Health Check ([`scripts/factory-doctor.sh`](file:///Users/cesaradalbertochavezcalderon/Personal/pinata-factory/scripts/factory-doctor.sh))**:
   - Automated diagnosis for `git`, `gh` CLI auth, `Node.js`, `npm`, Python 3, `ffmpeg`, and skill validity.

---

## Verification Results

### `scripts/factory-doctor.sh`
```
=========================================
       PINATA FACTORY DOCTOR CHECK       
=========================================

1. Git & GitHub Tooling
  [OK] Git: /usr/bin/git
       user.name:  cesarchavezcal
       user.email: cesarchavezcal@gmail.com
  [OK] GitHub CLI: /opt/homebrew/bin/gh
       GitHub Auth: Authenticated

2. Visual Regression & Headless Tools
  [OK] Node.js: v22.23.2
  [OK] npm: /Users/cesaradalbertochavezcalderon/.nvm/versions/node/v22.23.2/bin/npm
  [INFO] before-and-after CLI: Available via npx

3. Evidence Recorder Prerequisites
  [OK] Python 3: /usr/local/bin/python3
  [MISSING] FFmpeg / FFprobe (optional for headless testing; installable via brew)

4. Local Factory Skills (.agents/skills)
  [OK] Skill: new-feature
  [OK] Skill: code-structure
  [OK] Skill: unslop
  [OK] Skill: evidence-driven-testing
  [OK] Skill: before-and-after
  [OK] Skill: greploop
  [OK] Skill: greploop-apps
```

### Git Identity & Skill Registry
- Git local user identity configured: `cesarchavezcal` (`cesarchavezcal@gmail.com`).
- Skill registry indexed and synchronized: 63 skills indexed in `.atl/skill-registry.md`.
