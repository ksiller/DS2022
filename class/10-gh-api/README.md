# GitHub API

The [GitHub REST API](https://docs.github.com/en/rest) gives programs the same information you see on github.com: repositories, issues, users, and search results. Many endpoints work without logging in. Others, like the one that tells you who you are, need a **personal access token** (PAT). The token is an API key that lets `curl` act as you, with only the permissions you give it.

In this exercise you create a token, store it in an environment variable, send it in an HTTP header, call several GitHub endpoints, and read the status code and the JSON response.

You need a GitHub account, a terminal (Mac Terminal or WSL), `curl`, and `jq`. `jq` comes with recent macOS versions. On WSL, install it with `sudo apt install jq` if `jq --version` reports that it is missing.

## Step 1: Create a GitHub token

On [github.com](https://github.com), click your profile picture, then **Settings** → **Developer settings** → **Personal access tokens** → **Fine-grained tokens** → **Generate new token**.

| Field | Value |
|---|---|
| Token name | `ds2022-api` |
| Expiration | 7 days |
| Repository access | Public repositories (read-only) |

Leave everything else unchanged and click **Generate token**.

> [!IMPORTANT]
> GitHub shows the token only once. Copy it right away. Treat it like a password: never paste it into code, a slide, a chat, or a commit.

## Step 2: Store the token in an environment variable

Keep the token out of your commands. `curl` reads it from an environment variable instead.

```bash
read -s GH_TOKEN
```

Paste the token and press Enter. `read -s` does not show what you paste, and the token does not end up in your shell history. Now make the variable available to the programs you start from this terminal:

```bash
export GH_TOKEN
```

Check that the variable is set by printing its length, not its value:

```bash
echo ${#GH_TOKEN}
```

A number like `93` means the token is stored. `0` means the variable is empty: run `read -s GH_TOKEN` again.

The variable exists only in this terminal window. If you open a new window, repeat this step.

## Step 3: Authenticate with a header

The token travels in the `Authorization` header of the request, not in the URL:

```bash
curl -H "Authorization: Bearer $GH_TOKEN" \
     -H "Accept: application/vnd.github+json" \
     https://api.github.com/user
```

- `-H` adds an HTTP header to the request.
- `Authorization: Bearer ...` carries the token.
- `Accept: application/vnd.github+json` asks for GitHub's JSON format.
- `/user` returns the account the token belongs to: your login, name, and number of public repositories.

Now run the same request without the token:

```bash
curl https://api.github.com/user
```

```json
{
  "message": "Requires authentication",
  "documentation_url": "https://docs.github.com/rest",
  "status": "401"
}
```

`401 Unauthorized` means the server doesn't know who you are. `/user` has no meaning without an account.

## Step 4: Query a repository

To avoid typing the header every time, store it in a variable too. The variable holds `$GH_TOKEN` as part of its text, so it's as sensitive as the token itself:

```bash
AUTH="Authorization: Bearer $GH_TOKEN"
```

GitHub endpoints follow a pattern: `/repos/{owner}/{repo}` is one repository.

```bash
curl -H "$AUTH" https://api.github.com/repos/psf/requests
```

Add `/issues` to get that repository's issues, a different resource:

```bash
curl -H "$AUTH" https://api.github.com/repos/psf/requests/issues
```

How does this response differ from the previous one?

The search endpoint takes query parameters:

```bash
SEARCH="https://api.github.com/search/repositories"
curl -H "$AUTH" "$SEARCH?q=python&sort=stars&per_page=5"
```

What do `q`, `sort`, and `per_page` control? Change their values and compare the results. The quotes around the URL matter: without them, the shell treats `&` as "run in the background".

## Step 5: Inspect the response

Save the response body to a file and print only the status code:

```bash
curl -s -o repo.json -w "%{http_code}\n" \
     -H "$AUTH" \
     https://api.github.com/repos/psf/requests
```

- `-s` hides the progress output.
- `-o repo.json` writes the body to `repo.json` instead of the terminal.
- `-w "%{http_code}\n"` prints the status code after the request.

`200` means success. Pick the fields you need from the JSON with `jq`:

```bash
jq '{name, description, owner: .owner.login, stargazers_count, open_issues_count}' repo.json
```

```json
{
  "name": "requests",
  "description": "A simple, yet elegant, HTTP library.",
  "owner": "psf",
  "stargazers_count": 54715,
  "open_issues_count": 256
}
```

Your numbers will differ: they change as people star the repository and open issues.

Change `psf/requests` to a repository that doesn't exist and run the `curl` command again. Which status code comes back?

## Step 6: Discuss

1. What is the endpoint in each request?
2. What information does each endpoint return?
3. How do query parameters change the response?
4. What changes when you include the token? Compare the rate limits:

   ```bash
   curl -s https://api.github.com/rate_limit | jq .rate
   curl -s -H "$AUTH" https://api.github.com/rate_limit | jq .rate
   ```

   `limit` is the number of requests allowed per hour.

## Step 7: Clean up

Remove the token from your terminal session:

```bash
unset GH_TOKEN AUTH
```

Then delete the token on GitHub: **Settings** → **Developer settings** → **Personal access tokens** → **Fine-grained tokens**, click `ds2022-api`, then **Delete**. A token you no longer use is a risk, even with an expiration date.

## Resources

- [GitHub REST API documentation](https://docs.github.com/en/rest)
- [Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [Rate limits for the REST API](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api)
- [jq manual](https://jqlang.org/manual/)
