---
name: greploop-apps
description: "Trigger: review large PR with greptile, or greploop on huge changeset. Uses @greptile-apps to bypass file limits until 5/5 score."
license: MIT
metadata:
  author: greptileai
  version: "2.0"
---

# Greploop Apps

Iteratively refines large PRs, MRs, or changelists using `@greptile-apps` to bypass file-count thresholds until achieving a 5/5 review score.

## Activation Contract

- **Trigger:** Changeset exceeds standard Greptile file-count limits ("Too many files changed for review"), or user requests large PR review loops.
- **Review Trigger:** Always tags `@greptile-apps review` (instead of `@greptile review`).

## Hard Rules

- Must tag `@greptile-apps review` to bypass large-PR thresholds.
- Always post explicit trigger comment on every push (auto-review skips oversized PRs).
- Fallback to polling issue comment `updated_at` when check-runs are omitted for large PRs.
- Abort workflow if polling exceeds timeout limits.
- Respect `--max-iterations` (default 10).

## Decision Gates

| Check Run Emitted? | Polling Mechanism | Exit Condition |
|---|---|---|
| Yes | Poll check-run completion status | Check-run conclusion == success |
| No (Large PR) | Poll latest Greptile issue comment `updated_at` | Comment body contains valid score |
| Pipeline in progress | Wait and poll active pipeline | Pipeline completes |
| 5/5 score + 0 comments | Terminate loop | Output completion report |

## Execution Steps

1. Identify VCS platform and active PR/MR/CL identifier.
2. Push or re-shelve workspace changes: `git push` or `p4 shelve -f -c <CL>`.
3. Check active checks; if idle, comment: `gh pr comment <PR> --body "@greptile-apps review"`.
4. Poll check-run completion; if missing after 3 attempts, activate huge-PR issue comment polling.
5. Extract confidence score and unresolved comments from issue comments and reviews API.
6. Verify exit criteria: stop if 5/5 with zero unresolved comments or max iterations reached.
7. Fix actionable issues, resolve review threads via API, and commit changes.
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

## References

- [VCS Polling](references/vcs-polling.md): Large-PR issue comment fallback polling, platform polling loops, and thread resolution.
- [GitLab API](references/gitlab-api.md): GitLab discussion resolution and notes endpoints.
- [GraphQL Queries](references/graphql-queries.md): GitHub GraphQL review thread batch resolution.
