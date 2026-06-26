For your repo (`olajio/infra`), here's how to run it.

First, fill in the three placeholders at the top of the script. Based on your URL, owner and repo are already determined:

```bash
PAT="ghp_yourActualTokenHere"   # paste your real PAT
OWNER="olajio"
REPO="infra"
```

`BASE="main"` is already correct for you, and `API` stays as `https://api.github.com` since this is github.com (not Enterprise Server).

Then save the file (say as `test_pat_write.sh`) and run it:

```bash
# Make it executable (only needed once)
chmod +x test_pat_write.sh

# Run it
./test_pat_write.sh
```

Or without changing permissions:

```bash
bash test_pat_write.sh
```

What you should see on success:

```
Base main SHA: a1b2c3d4...
Create branch: 201
Write file:    201
Delete branch: 204
```

`201` / `201` / `204` means the PAT can create a branch, write a file, and delete the branch — full write access confirmed. If you see `403` or `404` on the create/write steps instead, the token doesn't have write access to `olajio/infra` (for a fine-grained PAT, that means it needs Contents: Read and write on this repo).

One dependency note: the script uses `jq` to parse the base SHA. If you get a `jq: command not found` error, install it first with `sudo apt install jq` (Debian/Ubuntu) or `brew install jq` (macOS).

Two cleanup caveats worth knowing: the script leaves the `.pat-write-test.txt` file committed on the test branch, but since the last step deletes that whole branch, nothing lingers on `main`. And if any step fails partway, `set -euo pipefail` will stop the script — so you may occasionally need to manually delete a leftover `pat-write-test-*` branch from the repo.
