# Git Worktree Guide: new-feature

Lifecycle, naming conventions, harness variations, and collision management for multi-agent Git worktrees.

---

## Directory & Branch Conventions

- **Worktree Base Directory:** Always place worktrees in a gitignored path so agent checkouts cannot be inadvertently committed:
  - `.worktrees/<task-name>`
  - `.claude/worktrees/<task-name>`
- **Branch Prefix:** Prefix branches to identify the responsible agent or task domain:
  - `agent/<task-name>-<suffix>` (e.g. `agent/billing-webhook-0917a`)

---

## Harness-Specific Variations

1. **Claude Code Native Worktrees:**
   - Claude Code automatically manages worktrees under `.claude/worktrees/<name>`.
   - Do **not** execute manual `git worktree add` or `git worktree remove`.
   - Retain harness-assigned branch names; follow conflict checks and dependency verification steps.
2. **Cursor Managed Worktrees:**
   - Cursor generates branches matching `worktree-*`.
   - Retain existing worktree path and branch; run local dependencies and runtime checks.
3. **Standard CLI / Bare Git:**
   - Full manual management: execute `git worktree add` and cleanup commands explicitly.

---

## Shared Resource Traps

Git worktrees isolate source code checkouts but **do not** isolate shared system resources:
- **Port Conflicts:** Dev servers bind globally. Confirm port ownership before testing:
  ```bash
  lsof -i :3000
  ss -ltnp "sport = :3000"
  ```
- **Database State:** Local SQLite or shared dev databases reflect mutations across all worktrees. Use isolated test schemas or tenant IDs.
- **Dependency Lockfiles:** Concurrent package updates across worktrees cause merge conflicts. Never manually edit lockfiles; reinstall and regenerate.

---

## Post-Merge Cleanup Lifecycle

Once the pull request is merged or closed:

```bash
# Remove worktree directory
git worktree remove .worktrees/<task-name>

# Force-delete local branch (-D required after squash or rebase merge)
git branch -D agent/<task-name>

# Prune stale worktree metadata
git worktree prune
```
