Quickest check is to hit the repo endpoint with the token and look at the HTTP status:

```bash
curl -s -o /dev/null -w "%{http_code}\n" \
  -H "Authorization: Bearer YOUR_PAT" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/OWNER/REPO
```

`200` means the token can read it, `404` means no access (GitHub returns 404 rather than 403 for repos the token can't see, to avoid leaking existence), and `401` means the token itself is bad/expired.

If you want to actually see the response body and useful headers (like scopes on a classic PAT):

```bash
curl -s -D - \
  -H "Authorization: Bearer YOUR_PAT" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/OWNER/REPO | head -40
```

Look at the `x-oauth-scopes` header to confirm the classic token carries `repo` (or `public_repo` for public-only). Fine-grained PATs won't populate that header — for those, the `200`/`404` from the first command is your signal.

A couple of notes for your setup: if you're hitting GitHub Enterprise Server instead of github.com, swap the host for `https://HOST/api/v3/repos/OWNER/REPO`. And to specifically prove read access to contents rather than just metadata, you can target a sub-resource like `.../repos/OWNER/REPO/contents/README.md`, since a token can sometimes see repo metadata without being able to pull file contents.
