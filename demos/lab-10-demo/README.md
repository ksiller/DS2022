# Demo: Call the Lab 10 web API

Instructor demo for [Lab 10](https://github.com/ksiller/lab-10-api): call the deployed Chalice API with `curl`, add a new book to the bucket, and follow it from S3 to the API and into a web browser. Concepts: [Class 10: FastAPI](../../class/10-fastapi/README.md) (endpoints, path parameters, status codes) and [Lab 07, Part 2](https://github.com/ksiller/lab-07-ec2-lambda#part-2-build-a-lambda-app-for-new-books) (the S3 trigger that analyzes new books).

Commands from the live demo in class. Run each command on its own.

> [!NOTE]
> The demo needs a deployed Lab 10 API (Lab 10, Step 2.5), with the provided `/page` route and the optional `/authors` route (Step 2.8). If you completed Lab 10, you can follow along with your own API.

## 0. Setup

1. On the **Learner Lab page**, click **Start Lab** and wait for the green **AWS** icon.
2. Click **AWS Details** → **AWS CLI** → **Show**. Copy the block into `~/.aws/credentials` on your computer (credentials change with every lab session). Check with `aws sts get-caller-identity`.

Change into the folder of your deployed Chalice app (in Lab 10: `book-analyzer/` in your clone):

```bash
cd ~/ds2022-fall-2026/lab-10-api/book-analyzer
```

Save the API's URL in the variable `API`:

```bash
API=$(uv run chalice url)
```

```bash
echo $API
```

It prints the URL, ending in `/api/`. The API is open: anyone who has the URL can call it, so do not post it anywhere.

## 1. All books

`GET /books` returns `_id`, `title`, and `author` of every book, sorted by title. `jq` prints the JSON in a readable form:

```bash
curl -s ${API}books | jq
```

Count the books:

```bash
curl -s ${API}books | jq length
```

## 2. One book

`GET /books/{key}` returns the document of one book. `-i` also prints the status line and the headers:

```bash
curl -i ${API}books/pg74.txt
```

It prints `HTTP/2 200` and the document of *The Adventures of Tom Sawyer*.

## 3. All authors

`GET /authors` returns every author once, sorted:

```bash
curl -s ${API}authors | jq
```

The names are spelled exactly as in the books' Project Gutenberg headers, for example `L. M. Montgomery`. The `?author=` filter in step 7 must match a name in this list exactly.

## 4. Download a new book from Project Gutenberg

*Anne of Avonlea* by L. M. Montgomery is book number 47 on [gutenberg.org](https://www.gutenberg.org/ebooks/47). Download single books by hand only: Project Gutenberg does not allow automated bulk downloads.

```bash
curl -sSo pg47.txt https://www.gutenberg.org/cache/epub/47/pg47.txt
```

Check the title and the author in the book's header:

```bash
head -40 pg47.txt | grep -E "^(Title|Author):"
```

It prints `Title: Anne of Avonlea` and `Author: L. M. Montgomery`.

## 5. Upload the book to S3

Replace `mst3k` with your computing ID:

```bash
aws s3 cp pg47.txt s3://public-mst3k/
```

The upload triggers the Lab 07 function `book-analyzer-dev-analyze_new_book`. It analyzes the book and saves its document in Atlas, with the S3 key `pg47.txt` as its `_id`.

## 6. Call the new book

Wait a few seconds, then call the book by its `_id`:

```bash
curl -i ${API}books/pg47.txt
```

It prints `HTTP/2 200` and the new document, without `llm_analysis`: the summary and the genre come from Lab 08, which did not run on this book. If it prints `404`, the function has not finished yet: wait a few seconds and call it again. If it stays `404`, read the function's log:

```bash
uv run chalice logs -n analyze_new_book
```

## 7. Check in a web browser

Print the three addresses, then open each one in a web browser:

```bash
echo "${API}books"
```

```bash
echo "${API}books/pg47.txt"
```

```bash
echo "${API}page?author=L.%20M.%20Montgomery"
```

| Address | What the browser shows |
| --- | --- |
| `.../api/books` | the JSON list of all books, now with *Anne of Avonlea* |
| `.../api/books/pg47.txt` | the JSON document of the new book |
| `.../api/page?author=L.%20M.%20Montgomery` | a web page with the books by L. M. Montgomery; each title links to its JSON document |

`%20` is a space, encoded for the URL. Firefox shows JSON in a readable form; in Chrome, check **Pretty-print**.

## 8. Clean up

Delete the downloaded file on your computer (the book stays in S3 and in Atlas):

```bash
rm pg47.txt
```
