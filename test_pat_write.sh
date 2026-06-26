#!/usr/bin/env bash
#
# Test whether a GitHub PAT can create a branch and write a file to a repo.
# Performs the real operations (branch create + file write), then cleans up.
#
# Usage:
#   ./test_pat_write.sh <PAT> <OWNER> <REPO> [BASE_BRANCH] [API_URL]
#
# Examples:
#   ./test_pat_write.sh ghp_xxx myorg myrepo
#   ./test_pat_write.sh ghp_xxx myorg myrepo develop
#   ./test_pat_write.sh ghp_xxx myorg myrepo main https://github.example.com/api/v3
#
set -euo pipefail

# --- Arguments ---------------------------------------------------------------
PAT="${1:?Usage: $0 <PAT> <OWNER> <REPO> [BASE_BRANCH] [API_URL]}"
OWNER="${2:?Missing OWNER}"
REPO="${3:?Missing REPO}"
BASE="${4:-main}"                     # branch to fork from (default: main)
API="${5:-https://api.github.com}"    # GHES: https://HOST/api/v3

TEST_BRANCH="pat-write-test-$(date +%s)"
AUTH=(-H "Authorization: Bearer $PAT" -H "Accept: application/vnd.github+json")

# --- 1. Get the SHA of the base branch ---------------------------------------
BASE_SHA=$(curl -s "${AUTH[@]}" \
  "$API/repos/$OWNER/$REPO/git/ref/heads/$BASE" | jq -r .object.sha)
echo "Base $BASE SHA: $BASE_SHA"
[ "$BASE_SHA" = "null" ] && { echo "Can't read base branch — check repo/branch/token"; exit 1; }

# --- 2. Create the new branch ------------------------------------------------
echo -n "Create branch: "
curl -s -o /dev/null -w "%{http_code}\n" "${AUTH[@]}" -X POST \
  "$API/repos/$OWNER/$REPO/git/refs" \
  -d "{\"ref\":\"refs/heads/$TEST_BRANCH\",\"sha\":\"$BASE_SHA\"}"

# --- 3. Write a file to the new branch ---------------------------------------
echo -n "Write file:    "
CONTENT=$(printf 'pat write test' | base64)
curl -s -o /dev/null -w "%{http_code}\n" "${AUTH[@]}" -X PUT \
  "$API/repos/$OWNER/$REPO/contents/.pat-write-test.txt" \
  -d "{\"message\":\"pat write test\",\"content\":\"$CONTENT\",\"branch\":\"$TEST_BRANCH\"}"

# --- 4. Clean up — delete the test branch ------------------------------------
echo -n "Delete branch: "
curl -s -o /dev/null -w "%{http_code}\n" "${AUTH[@]}" -X DELETE \
  "$API/repos/$OWNER/$REPO/git/refs/heads/$TEST_BRANCH"
