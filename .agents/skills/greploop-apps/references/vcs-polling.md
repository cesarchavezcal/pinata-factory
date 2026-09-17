# VCS Polling & Large-PR Fallback: greploop-apps

Detailed polling strategies, huge-PR issue comment fallback routines, and review parsing.

---

## The `@greptile-apps` Trigger

When PR changesets exceed standard file limits, `@greptile` triggers return:
`Too many files changed for review`.
Using `@greptile-apps review` instructs the Greptile backend to process large multi-file diffs. Because automatic review hooks are disabled for these oversized PRs, each push requires an explicit trigger comment.

---

## Huge-PR Comment Polling Fallback (GitHub)

On very large PRs, Greptile may not emit a GitHub check-run for the new commit SHA. Instead, it directly edits its existing summary issue comment upon completing analysis.

```bash
TRIGGER_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ATTEMPTS=0
MAX_ATTEMPTS=60
POLL_INTERVAL=10

while true; do
  ATTEMPTS=$((ATTEMPTS + 1))
  if [ "$ATTEMPTS" -gt "$MAX_ATTEMPTS" ]; then
    echo "Timed out waiting for Greptile comment update (10m)." >&2
    exit 1
  fi

  # Fetch latest Greptile issue comment
  COMMENT_DATA=$(gh api --paginate "repos/{owner}/{repo}/issues/<PR_NUMBER>/comments?per_page=100"     --jq '[.[] | select(.user.login | test("greptile"; "i"))] | sort_by(.updated_at) | last')

  UPDATED_AT=$(echo "$COMMENT_DATA" | jq -r '.updated_at // empty')
  BODY=$(echo "$COMMENT_DATA" | jq -r '.body // empty')

  # Check if comment updated after our trigger and contains confidence score
  if [ -n "$UPDATED_AT" ] && [[ "$UPDATED_AT" > "$TRIGGER_TIME" ]]; then
    if echo "$BODY" | grep -Eq "([0-5]/5|Confidence:)"; then
      echo "Greptile completed review on huge PR."
      break
    fi
  fi

  echo "Waiting for Greptile summary update... (attempt $ATTEMPTS)"
  sleep "$POLL_INTERVAL"
done
```

---

## Standard Check-Run Polling

```bash
HEAD_SHA=$(gh pr view <PR_NUMBER> --json headRefOid -q .headRefOid)
ATTEMPTS=0

while [ "$ATTEMPTS" -lt 60 ]; do
  ATTEMPTS=$((ATTEMPTS + 1))
  GREPTILE_CHECK=$(gh api "repos/{owner}/{repo}/commits/$HEAD_SHA/check-runs"     --jq '.check_runs[] | select(.name | test("greptile"; "i"))' 2>/dev/null)

  # If no check run appears after 3 attempts, switch to comment polling
  if [ -z "$GREPTILE_CHECK" ] && [ "$ATTEMPTS" -ge 3 ]; then
    echo "Check run absent; activating huge-PR comment polling fallback."
    break
  fi

  STATUS=$(echo "$GREPTILE_CHECK" | jq -r '.status // "completed"')
  if [ "$STATUS" = "completed" ]; then
    echo "Check run completed."
    break
  fi
  sleep 10
done
```

---

## Discussion Thread Resolution

### GitHub (GraphQL Mutation)
```bash
gh api graphql -f query='
mutation {
  resolveReviewThread(input: {threadId: "<THREAD_ID>"}) {
    thread { isResolved }
  }
}'
```

### GitLab (REST PUT)
```bash
glab api --method PUT   "projects/:fullpath/merge_requests/<MR_IID>/discussions/<DISCUSSION_ID>"   --field resolved=true
```
