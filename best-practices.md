# Best Practices for Readable and Maintainable Code

Use this page as a guide. You do not need to satisfy every item perfectly, but your code should reflect these principles where they apply.

## General

### Don't share passwords and credentials

- Never put cleartext passwords, credentials, or tokens in scripts or other files. You do not want to publish them when you push to GitHub.
- Use environment variables or a private config file for secrets, and read them in your scripts at runtime.

### Keep code easy to read

- Use clear names (`input_file`, `bucket_name`, `results_df`) instead of vague short names (`x`, `tmp`, `data1`), except in short loops.
- Keep functions and scripts focused on one task.
- Prefer simple control flow over clever one-liners.
- Avoid copy-paste blocks; write a reusable function instead.

### Comment with purpose

- Write comments that explain **why**, not the obvious **what**.
- Do not comment every line. Add a short comment before non-obvious logic.
- Keep comments current; remove stale comments when the code changes.

### Organize project files

- Keep source code, data, and outputs in separate folders.
- Do not commit large generated output files to GitHub unless required.
- Do not commit secrets (keys, passwords, or `.env` files that contain credentials).
- Use `.gitignore` to exclude sensitive and generated files from tracking. That reduces the risk of accidental leaks into a public repository.

### Make your project reproducible

- Include a clear `README.md` with:
  - project goal
  - setup instructions
  - how to run
  - expected outputs
- List Python packages in a `requirements.txt` or `pyproject.toml` file at the top level of the repository.
- Document assumptions (input paths, expected schema, required environment variables).

## Python

### Use functions

- Organize code into functions, each with a single responsibility.
- Use meaningful function names.
- Add a docstring to each function (at least one sentence).
- Use:

```python
if __name__ == "__main__":
    main()
```

### Prefer a `main()` workflow

- Parse inputs once.
- In your main script(s), call helper functions from `main()`.

### Handle external calls with `try/except`

Wrap calls to external services (for example `boto3.client()`, database clients, HTTP requests, and file I/O) in `try/except` so failures are understandable.

- Catch specific exceptions when possible.
- Log useful context in the error message.
- Exit with a non-zero status on unrecoverable errors.

### Use command-line arguments

Use command-line arguments so users can pass options into the script. `sys.argv` is fine for simple cases; for richer interfaces see [`argparse`](https://docs.python.org/3/library/argparse.html).

### Use logging (not only `print`)

- Use `logging` for status, warnings, and errors.
- For larger scripts, include a command-line option to control log level (`INFO`, `DEBUG`, and so on).
- Keep user-facing output concise; avoid noisy logs by default.

### Keep imports clean

- Remove unused imports.
- Group imports in this order: standard library, third-party, local modules.
- Avoid importing inside functions unless necessary.

## Bash

### Safer shell scripts

Start scripts with:

```bash
set -euo pipefail
```

- Quote variable expansions (`"$FILE"`, not `$FILE`).
- Validate positional arguments before use.
- Print a usage message for incorrect invocation.
- Use exit codes (`exit 1`) on failure.

### Write portable commands

- Avoid hard-coding user-specific paths unless necessary.
- Add short comments for non-obvious commands.

### Validate inputs early

- Check that files and folders exist before processing.
- Validate expected columns or fields in datasets and databases before running heavy logic.
- Fail fast with clear messages when assumptions are violated.

### Be explicit with cloud resources

- Name resources consistently (`ds2022-<computing_id>-...` when required).
- Keep region settings explicit when relevant (`us-east-1` in this course).
- Clean up cloud resources after testing to avoid charges.

## Testing and verification

### Test small, then full

- Run on a tiny sample first.
- Add at least one negative test (missing file, bad argument, permission issue).
- Verify output format and counts, not just that the script runs.
