---
name: new-feature
description: "Trigger: start new task, create worktree, or isolate branch. Sets up an isolated Git worktree from origin/main for parallel work."
license: MIT
metadata:
  author: michaelshimeles
  version: "2.0"
---

# New Feature

Isolate every task into a dedicated Git worktree branched from latest `origin/main` for collision-free parallel agent workflows.

## Activation Contract

- **Trigger:** Start of any new feature, bug fix, or task before writing any code.
- **Scope:** Repository setup, branch isolation, conflict inspection, and post-merge cleanup.

## Hard Rules

- Never develop directly on `main`.
- Never reuse or share another agent's active worktree or branch.
- If target files are modified by open PRs, stop and request user guidance.
- Worktrees must reside in gitignored directories (e.g. `.worktrees/`, `.claude/worktrees/`).
- Never hand-merge lockfiles; regenerate them cleanly within the worktree.

## Decision Gates

| Environment | Worktree Action | Branch Naming |
|---|---|---|
| Claude Code | Skip manual `worktree add`; harness creates it | Keep harness-assigned branch |
| Cursor (`worktree-*`) | Use pre-allocated Cursor worktree | Keep assigned branch |
| Standard CLI / Other | Run `git worktree add <dir> -b <branch>` | Use `agent/<task-name>` pattern |
| Overlapping Open PR | Halt execution and prompt user | Do not create conflicting branch |

## Execution Steps

1. Fetch latest upstream repository state: `git fetch origin`.
2. Inspect open pull requests for file conflicts: `gh pr list` and `gh pr diff <n> --name-only`.
3. Select task name: lowercase with hyphens plus short unique suffix (e.g. `auth-flow-0917a`).
4. Create worktree: `git worktree add .worktrees/<task> -b agent/<task> origin/main`.
5. Enter worktree and verify branch: `cd .worktrees/<task> && git branch --show-current`.
6. Install isolated dependencies and verify language runtime.
7. Post-merge cleanup: `git worktree remove .worktrees/<task> && git branch -D agent/<task>`.

## Output Contract

- Absolute path to the isolated worktree directory.
- Verified active branch name.
- Confirmation of clean dependency installation.

## References

- [Worktree Guide](references/worktree-guide.md): Port conflict management, harness variations, and cleanup workflows.
