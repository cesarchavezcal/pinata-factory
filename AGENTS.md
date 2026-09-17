# Agent workflow

Every task moves through the same four beats, each backed by a skill installed in `.agents/skills/` (see [Skill sources](#skill-sources)). This file governs all work in `pinata-factory`.

## Workflow

1. **Isolate — `/new-feature`.** Every new feature starts in a fresh Git worktree branched from `origin/main` so agents can work in parallel without conflicts. Never build on `main`.
2. **Build — `/code-structure`.** Write code to the service-layer architecture: actions/boundaries orchestrate the "why/when", a service layer owns the reusable "how", with explicit inputs and structured returns.
3. **Prove — `/evidence-driven-testing`.** Verify with the repo's checks plus runtime evidence. Capture the **before** state while reproducing the issue — prior to fixing it, when it is cheapest — and the **after** once the change works.
4. **Ship — `/before-and-after`, then `/greploop`.** Open the PR with before/after proof embedded in the description (screenshot or video whenever the change has a visible surface; measured numbers or output pairs when it doesn't). Run `/greploop` — or `/greploop-apps` when the PR exceeds Greptile's file-count limit — until Greptile reports **5/5 with zero unresolved comments**. Finish by presenting the PR URL.

Ship-beat notes:

- `/before-and-after` drives the `@vercel/before-and-after` CLI. `--markdown` uploads the pair and prints a PR-ready table; it also accepts existing PNGs, so evidence gathered while developing can be reused as-is.
- In containers/VMs where Chrome fails with "No usable sandbox", set `AGENT_BROWSER_ARGS="--no-sandbox"` for the capture command.
- The default upload host (0x0.st) is public — fine for ordinary UI shots; pass `--upload-url` for anything sensitive.

## Writing for humans

Run `/unslop` over anything a person will read, before you commit, post, or send it: commit messages, the PR title and body, README and doc edits, code comments, and the closing reply. It strips AI tells (em dashes, filler, hedging, chatbot phrases, puffery, bold-label lists) and replaces fancy words with plain ones and passive voice with active. Apply it to text you wrote or changed, not to prose you didn't touch.

## Multi-agent rules

- Never commit directly to `main`.
- One worktree and one branch per task and per agent — never reuse or modify another agent's worktree, branch, or uncommitted work.
- **Scope check** before starting: skim open PRs' changed files (`gh pr list`, `gh pr diff <n> --name-only`) and look for uncommitted work in shared checkouts. On overlap, stop and ask for direction.
- Never force-push to `main` — and never plain `--force` anywhere; only `--force-with-lease`, only on your own task branch.
- Resolve lockfile conflicts by regenerating, never by hand-merging.
- Worktrees don't isolate shared resources: confirm a dev-server port answers *your* process before trusting it, and don't run schema experiments against a shared database.
- If a conflict can't be resolved confidently, stop and report instead of guessing.

## Completing a task

1. Keep changes limited to the assigned task.
2. Run the repo's checks (`./scripts/factory-doctor.sh`).
3. Assemble the evidence captured along the way into before/after pairs.
4. Commit with a clear message, rebase onto the latest `origin/main`, and rerun the checks.
5. Push (`git push -u origin <branch>`; after rebasing an already-pushed branch, `--force-with-lease`).
6. Open the PR. The body must explain what changed, how it was tested (every claim backed by evidence), before/after proof, and any risks or follow-up work. Run the title and body through `/unslop` before posting.
7. Run `/greploop` (or `/greploop-apps`) until **5/5 with zero unresolved comments**.
8. End by presenting the PR URL.

Do not merge the PR unless explicitly instructed. Keep the worktree until the PR is merged or closed.

## Repo-specific setup & checks

- **Doctor:** Run `./scripts/factory-doctor.sh` to check toolchain health (`git`, `gh`, `@vercel/before-and-after`, Python 3, `ffmpeg`).
- **Skill index:** Run `gentle-ai skill-registry refresh` whenever skills or triggers are updated.
- **Identity:** Local commits must be attributed to `cesarchavezcal`.

## Skill sources

| Skill | Path | Description |
|---|---|---|
| `new-feature` | `.agents/skills/new-feature/SKILL.md` | Worktree isolation from origin/main |
| `code-structure` | `.agents/skills/code-structure/SKILL.md` | Service-layer architecture separation |
| `unslop` | `.agents/skills/unslop/SKILL.md` | Strips AI tells and synthetic patterns from human prose |
| `evidence-driven-testing` | `.agents/skills/evidence-driven-testing/SKILL.md` | Live hands-on UI test recording and assertion subtitles |
| `before-and-after` | `.agents/skills/before-and-after/SKILL.md` | Dual screenshot capture and PR markdown diff table |
| `greploop` | `.agents/skills/greploop/SKILL.md` | Autonomous Greptile review loop until 5/5 score |
| `greploop-apps` | `.agents/skills/greploop-apps/SKILL.md` | Greptile loop variant for large PRs bypassing file limits |
