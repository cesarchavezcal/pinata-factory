---
name: greploop
description: "Trigger: optimize PR review, fix greptile comments, or run greploop. Iterates review and fixes until 5/5 score and zero comments."
license: MIT
metadata:
  author: greptileai
  version: "2.0"
---

# Greploop

Iteratively improves a PR, MR, or shelved changelist until Greptile yields a 5/5 confidence score with zero unresolved comments.

## Activation Contract

- **Trigger:** User asks to optimize PR/MR/CL, achieve 5/5 review confidence, address all Greptile feedback, or run `greploop`.
- **Supported VCS:** GitHub (`gh`), GitLab (`glab`), or Perforce (`p4` / Helix Swarm).

## Hard Rules

- Always enforce `--max-iterations` (default 10); never permit runaway loops.
- Abort workflow if Greptile check-run or pipeline polling times out.
- Never resolve review threads without implementing a code fix or documenting a verified false positive.
- Never push or re-shelve unverified code.
- Always use `updated_at` timestamps when parsing Greptile summary comments.

## Decision Gates

| Review Status | Unresolved Threads | Iteration Count | Action |
|---|---|---|---|
| Confidence 5/5 | 0 | Any | Terminate loop and report success |
| Any | Any | >= max-iterations | Terminate loop and report remaining issues |
| Check in progress | Any | < max-iterations | Wait and poll; do not trigger duplicate review |
| Actionable findings | > 0 | < max-iterations | Implement code fix, resolve thread, and push |

## Execution Steps

1. Detect VCS platform (`p4 info` or `git remote`) and extract active PR/MR/CL ID.
2. Push or re-shelve workspace changes: `git push` or `p4 shelve -f -c <CL>`.
3. Check running review status; if idle, trigger review: `gh pr comment <PR> --body "@greptile review"`.
4. Poll Greptile check-run or pipeline until completion (max 60 attempts, 10s interval).
5. Parse confidence score and collect unresolved inline comments from issue comments and review endpoints.
6. Evaluate exit conditions: exit if 5/5 with zero unresolved comments or max iterations reached.
7. Address actionable comments, resolve discussion threads via API, and commit changes.
8. Push or re-shelve and return to Step 3.

## Output Contract

Structured summary block:
```text
Greploop complete.
  Platform:      <GitHub|GitLab|Perforce>
  Iterations:    <count>
  Confidence:    5/5
  Resolved:      <count> comments
  Remaining:     0
```
(If stopped by max iterations, list remaining issues with file paths and line numbers.)

## References

- [VCS Polling](references/vcs-polling.md): Polling loops, timeout handling, review parsing, and thread resolution scripts.
- [GitLab API](references/gitlab-api.md): GitLab discussion resolution and notes endpoints.
- [GraphQL Queries](references/graphql-queries.md): GitHub GraphQL review thread batch resolution.
