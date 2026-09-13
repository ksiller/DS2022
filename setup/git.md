# Set Up Git / GitHub

Setting up Git and authenticating with GitHub is an important first step in managing your code. Follow these steps in order:

1. If you followed the [general setup instructions](GENERAL.md), you should have Git installed. If not, complete that setup now. A graphical Git client is optional, but the command-line version is required for this course.
2. Confirm that Git is installed: open a terminal window and run `git --version`.
3. Create a **classic** Personal Access Token (PAT). GitHub will not accept your account password on the command line. When Git later asks for a password, paste this token instead.

   Use a **classic** token, not a fine-grained one. Fine-grained tokens are limited to repositories you pick in advance, and they often fail when you collaborate on a classmate's repo. A classic token with the `repo` scope works on any repository you already have access to.

   First, [sign in to GitHub](https://github.com). Then start the classic token form in one of these ways:
   - Open [https://github.com/settings/tokens](https://github.com/settings/tokens), click **Generate new token**, and choose **Generate new token (classic)**, or
   - Click your profile picture (top right) → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)** → **Generate new token** → **Generate new token (classic)**.

   GitHub's walkthrough: [Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic).

   On the form:
   - Give the token a name, such as `DS2022 Git`.
   - Set an expiration date (the end of the semester is a reasonable choice).
   - Under **Select scopes**, check **`repo`**. That is enough to clone, pull, and push, including on shared repositories.
   - Click **Generate token**. GitHub shows the token **once**. Copy it somewhere secure. Do not share it or commit it to a repository. Treat it like a password.
4. When you clone or otherwise access a GitHub repository using an HTTPS URL, Git may ask for your GitHub username and password.
   - When prompted for your username, enter your GitHub username.
   - When prompted for your password, paste your Personal Access Token. GitHub does not actually use your account password for Git operations.

## THE FIRST TIME YOU USE GIT

The first time you use Git, you will encounter a couple of setup prompts:

- The first time you access a GitHub repository using HTTPS, Git may ask for your GitHub username and password. Enter your GitHub username, then paste your Personal Access Token (PAT) instead of your GitHub password. You may also be prompted to save your credentials in your operating system's credential manager so you do not have to enter the token every time.
- The first time you commit on your laptop, Git will ask you to set your name and email. These identify you in the commit log. Replace the values in quotes with your own information:

```text
git config --global user.name "Neal Magee"
git config --global user.email "nem2p@virginia.edu"
```

**Note:** Your Git commit name and email identify you as the author of commits. They are separate from your GitHub authentication credentials.

## WINDOWS USERS

Git for Windows includes Git Bash, which provides a Unix-like command-line environment. You do not need to create or manage SSH keys for this setup.

When using Git with GitHub, make sure you are cloning the repository using the HTTPS URL. On the GitHub repository page, select **Code** → **HTTPS** and copy the URL. It will look something like `https://github.com/USERNAME/REPOSITORY.git`.

When Git asks for your credentials:

- Username: your GitHub username
- Password: your Personal Access Token

You may also be prompted to authenticate through Git Credential Manager, which can securely manage your GitHub credentials.

You will know your setup is working correctly when you can clone a repository, modify a file, then `git add`, `git commit`, and `git push` those changes back to GitHub.
