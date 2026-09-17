# VCS Polling & Review Parsing: greploop

Polling scripts, review parsing algorithms, and thread resolution commands across GitHub, GitLab, and Perforce.

---

## 1. VCS Platform Detection

```bash
if p4 info >/dev/null 2>&1; then
  VCS="perforce"
else
  REMOTE_URL=$(git remote get-url origin)
  if echo "$REMOTE_URL" | grep -qi "gitlab"; then
    VCS="gitlab"
  else
    VCS="github"
  fi
fi
```

Override via `--vcs gitlab` or `--vcs perforce` if repository host is ambiguous.

---

## 2. Identify PR / MR / CL

- **GitHub:** `gh pr view --json number,headRefName,headRefOid -q '{number: .number, branch: .headRefName, sha: .headRefOid}'`
- **GitLab:** `glab mr view --output json | jq '{iid: .iid, branch: .source_branch, sha: .sha}'`
- **Perforce:** `p4 changes -s pending -u $P4USER -c $P4CLIENT` and `p4 describe -s <CL_NUMBER>`

---

## 3. GitHub Polling & Trigger Loop

### Check Active Review
```bash
GREPTILE_STATE=$(gh pr checks <PR_NUMBER> --json name,state | jq -r '.[] | select(.name | test("greptile"; "i")) | .state')
if [ "$GREPTILE_STATE" != "PENDING" ] && [ "$GREPTILE_STATE" != "IN_PROGRESS" ]; then
  gh pr comment <PR_NUMBER> --body "@greptile review"
fi
```

### Polling Check Run
```bash
HEAD_SHA=$(gh pr view <PR_NUMBER> --json headRefOid -q .headRefOid)
ATTEMPTS=0
MAX_ATTEMPTS=60
POLL_INTERVAL=10

while true; do
  ATTEMPTS=$((ATTEMPTS + 1))
  if [ "$ATTEMPTS" -gt "$MAX_ATTEMPTS" ]; then
    echo "Timed out waiting for Greptile check run (10m)." >&2
    exit 1
  fi

  GREPTILE_CHECK=$(gh api "repos/{owner}/{repo}/commits/$HEAD_SHA/check-runs"     --jq '.check_runs[] | select(.name | test("greptile"; "i"))' 2>/dev/null)

  if [ -z "$GREPTILE_CHECK" ]; then
    sleep "$POLL_INTERVAL"
    continue
  fi

  STATUS=$(echo "$GREPTILE_CHECK" | jq -r '.status // "completed"')
  CONCLUSION=$(echo "$GREPTILE_CHECK" | jq -r '.conclusion // "pending"')

  if [ "$STATUS" = "completed" ]; then
    break
  fi
  sleep "$POLL_INTERVAL"
done
```

---

## 4. GitLab Polling Loop

```bash
HEAD_SHA=$(glab mr view <MR_IID> --output json | jq -r '.sha')
ATTEMPTS=0
MAX_ATTEMPTS=60

while true; do
  ATTEMPTS=$((ATTEMPTS + 1))
  if [ "$ATTEMPTS" -gt "$MAX_ATTEMPTS" ]; then
    echo "Timed out waiting for Greptile pipeline job." >&2
    exit 1
  fi

  PIPELINES=$(glab api "projects/:fullpath/merge_requests/<MR_IID>/pipelines")
  PIPELINE_ID=$(echo "$PIPELINES" | jq -r --arg sha "$HEAD_SHA"     '[.[] | select(.sha == $sha)] | sort_by(.id) | last | .id // empty')

  if [ -n "$PIPELINE_ID" ]; then
    JOBS=$(glab api "projects/:fullpath/pipelines/$PIPELINE_ID/jobs")
    GREPTILE_JOB=$(echo "$JOBS" | jq '.[] | select(.name | test("greptile"; "i"))')
    JOB_STATUS=$(echo "$GREPTILE_JOB" | jq -r '.status // empty')
    if [ "$JOB_STATUS" = "success" ] || [ "$JOB_STATUS" = "failed" ] || [ "$JOB_STATUS" = "canceled" ]; then
      break
    fi
  fi
  sleep 10
done
```

---

## 5. Review Parsing & Score Extraction

Greptile scores appear in three locations; select the entry with latest `updated_at`:
1. **GitHub PR Description:** `gh pr view <PR> --json body -q .body`
2. **Issue Comments:**
   ```bash
   gh api --paginate "repos/{owner}/{repo}/issues/<PR>/comments?per_page=100" |      jq '[.[] | select(.user.login | test("greptile"; "i"))] | sort_by(.updated_at) | last'
   ```
3. **PR Reviews:** `gh api repos/{owner}/{repo}/pulls/<PR>/reviews`
4. **Unresolved Inline Comments:** `gh api repos/{owner}/{repo}/pulls/<PR>/comments`

---

## 6. Thread Resolution

### GitHub (GraphQL)
```bash
gh api graphql -f query='
mutation {
  t1: resolveReviewThread(input: {threadId: "<THREAD_ID_1>"}) { thread { isResolved } }
}'
```

### GitLab (REST)
```bash
glab api --method PUT "projects/:fullpath/merge_requests/<MR_IID>/discussions/<DISCUSSION_ID>" --field resolved=true
```
