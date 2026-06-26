Quick fix — install it. Pick the line for your system:

```bash
# Debian / Ubuntu (incl. WSL)
sudo apt update && sudo apt install -y jq

# RHEL / CentOS / Amazon Linux
sudo yum install -y jq        # or: sudo dnf install -y jq

# macOS (Homebrew)
brew install jq
```

Then verify and re-run:

```bash
jq --version
./test_pat_write.sh
```

If you don't have `sudo` on this box (common on locked-down work workstations), you can sidestep `jq` entirely by parsing the SHA with `grep`/`sed` instead. Swap the `BASE_SHA=` line in the script for this:

```bash
BASE_SHA=$(curl -s "${AUTH[@]}" \
  "$API/repos/$OWNER/$REPO/git/ref/heads/$BASE" \
  | grep -m1 '"sha"' | sed -E 's/.*"sha": *"([^"]+)".*/\1/')
```

That pulls the same value with tools already on every system. The one tradeoff is it's slightly more fragile than `jq` if GitHub ever reorders the JSON, but for this endpoint it's reliable.
