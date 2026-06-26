#!/usr/bin/env bash
set -euo pipefail
PAT="YOUR_PAT"
OWNER="OWNER"
REPO="REPO"
BASE="main"                          # branch to fork from
TEST_BRANCH="pat-write-test-$(date +%s)"
API="https://api.github.com"         # GHES: https://HOST/api/v3
AUTH=(-H "Authorization: Bearer $PAT" -H "Accept: application/vnd.github+json")

# 1. Test READ access to the repo
echo -n "Read repo:     "
READ_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${AUTH[@]}" \
  "$API/repos/$OWNER/$REPO")
echo "$READ_CODE"
case "$READ_CODE" in
  200) ;;                                                                   # readable, continue
  404) echo "No read access (or repo doesn't exist) — check repo/token"; exit 1 ;;
  401) echo "Bad or expired token"; exit 1 ;;
  *)   echo "Unexpected status on read — stopping"; exit 1 ;;
esac

# 2. Get the SHA of the base branch
BASE_SHA=$(curl -s "${AUTH[@]}" \
  "$API/repos/$OWNER/$REPO/git/ref/heads/$BASE" \
  | grep -m1 '"sha"' | sed -E 's/.*"sha": *"([^"]+)".*/\1/')

# 3. Create the new branch
echo -n "Create branch: "
curl -s -o /dev/null -w "%{http_code}\n" "${AUTH[@]}" -X POST \
  "$API/repos/$OWNER/$REPO/git/refs" \
  -d "{\"ref\":\"refs/heads/$TEST_BRANCH\",\"sha\":\"$BASE_SHA\"}"

# 4. Write a file to the new branch
echo -n "Write file:    "
CONTENT=$(printf 'pat write test' | base64)
curl -s -o /dev/null -w "%{http_code}\n" "${AUTH[@]}" -X PUT \
  "$API/repos/$OWNER/$REPO/contents/.pat-write-test.txt" \
  -d "{\"message\":\"pat write test\",\"content\":\"$CONTENT\",\"branch\":\"$TEST_BRANCH\"}"

# 5. Clean up — delete the test branch
echo -n "Delete branch: "
curl -s -o /dev/null -w "%{http_code}\n" "${AUTH[@]}" -X DELETE \
  "$API/repos/$OWNER/$REPO/git/refs/heads/$TEST_BRANCH"
