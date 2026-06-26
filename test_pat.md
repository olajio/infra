The PAT is now the first argument, with owner, repo, base branch, and API URL following. The base branch and API URL are optional and default to `main` and `https://api.github.com`.

To run it, make it executable once, then call it with your arguments:

```bash
chmod +x test_pat_write.sh

# Basic — github.com, defaults base branch to main
./test_pat_write.sh ghp_yourTokenHere myorg myrepo

# Specify a different base branch
./test_pat_write.sh ghp_yourTokenHere myorg myrepo develop

# GitHub Enterprise Server (pass base branch + API URL)
./test_pat_write.sh ghp_yourTokenHere myorg myrepo main https://github.example.com/api/v3
```

One small security note since you'll be passing the token on the command line: it'll show up in your shell history and in the process list (`ps`) while running. To keep it out of history, prefix the command with a space (works if your shell has `HISTCONTROL=ignorespace` set), or read it from an environment variable instead — happy to tweak the script to accept `GITHUB_PAT` from the env as a fallback if you'd prefer that pattern.
