# Build an API with FastAPI

An **API** (application programming interface) is a way for one program to request data or an action from another. In this exercise, the other program is a small web server you run on your own computer with [FastAPI](https://fastapi.tiangolo.com). A client (your browser, the `curl` command, or another script) sends an HTTP request to a URL. A Python function handles that request and returns a dictionary. FastAPI converts the dictionary to JSON and sends it back.

You will build a Book API: a welcome message, the list of books, and one book looked up by its id. You will call those endpoints from the terminal, try the same calls on the documentation page, and add an endpoint that creates a new book. You can write that endpoint yourself, or ask Claude Code to write it.

This API runs on your computer. In Lab 10, you will develop an API with Chalice, deploy it to AWS, and connect it to the book documents in your MongoDB Atlas cluster.

## Step 1: Setup

```bash
mkdir -p ~/ds2022-fall-2026/
cd ~/ds2022-fall-2026/
uv init my_api
cd my_api
```

Add the `fastapi` package.

```bash
uv add "fastapi[standard]"
```

## Step 2: Create an API

Create the file `src/main.py` with the contents below. If your project has no `src` folder, run `mkdir -p src` first.

```python
from fastapi import FastAPI, HTTPException

# Create the API application
app = FastAPI()

# Sample book data
books = {
    1: {"title": "Pride and Prejudice", "author": "Jane Austen"},
    2: {"title": "Frankenstein", "author": "Mary Shelley"},
    3: {"title": "Moby Dick", "author": "Herman Melville"}
}

# Define an API endpoint
@app.get("/")
def home():
    return {"message": "Welcome to the Book API"}

# Retrieve all books
@app.get("/books")
def get_books():
    return books

# Retrieve one book by ID
@app.get("/books/{book_id}")
def get_book(book_id: int):
    if book_id not in books:
        raise HTTPException(status_code=404, detail=f"Book {book_id} not found")
    return books[book_id]
```

- `FastAPI()` creates the API application.
- `@app.get()` registers a function as a handler for HTTP GET requests.
- `/books` is an API endpoint.
- `/books/{book_id}` uses a path parameter to identify a specific book.
- Each function returns a Python dictionary, which FastAPI converts to JSON.

| FastAPI decorator | HTTP method | Purpose |
|---|---|---|
| `@app.get()` | GET | Retrieve books |
| `@app.post()` | POST | Add a new book |
| `@app.put()` | PUT | Replace a book |
| `@app.delete()` | DELETE | Delete a book |

## Step 3: Start the API

```bash
uv run fastapi dev src/main.py
```

This starts your FastAPI server, typically at http://127.0.0.1:8000. Your address and port may differ. Use the URL printed in the server output for the commands below. Leave this terminal running.

## Step 4: Test the API

Open a second terminal. The first one is running the server. Call the API from this terminal with `curl`, or open the URLs in a browser.

**A. Welcome message**

```bash
curl http://127.0.0.1:8000/
```

Response:

```text
{"message":"Welcome to the Book API"}
```

**B. Retrieve all books**

The route in `src/main.py` is `/books`, with no slash after `books`. **Do not add a trailing `/`.** `/books/` is a different path. FastAPI answers it with a redirect and an empty body, and `curl` does not follow that redirect, so the command prints nothing.

```bash
curl http://127.0.0.1:8000/books
```

Response (`curl` prints this on one line):

```text
{"1":{"title":"Pride and Prejudice","author":"Jane Austen"},"2":{"title":"Frankenstein","author":"Mary Shelley"},"3":{"title":"Moby Dick","author":"Herman Melville"}}
```

JSON object keys are strings, so each id appears in quotes (`"1"`, `"2"`, `"3"`) even though the Python dictionary uses integers.

**C. Retrieve one book**

```bash
curl http://127.0.0.1:8000/books/2
```

Response:

```text
{"title":"Frankenstein","author":"Mary Shelley"}
```

## Step 5: Explore automatic API documentation

FastAPI builds a description of your API from the code: each path, HTTP method, parameter, and response. [Swagger UI](https://github.com/swagger-api/swagger-ui) is a web page that turns that description into a form. You pick an endpoint, fill in any parameters, and send a real request to the server you started in Step 3. The page shows the status code and the JSON body. The same description is available as JSON at http://127.0.0.1:8000/openapi.json. Swagger UI is the readable view of that JSON.

**Open:** http://127.0.0.1:8000/docs

If the server printed a different address or port, use that URL instead.

Each endpoint is a row. Click the row to expand it, click **Try it out**, fill in parameters if the row has any, then click **Execute**.

Try these three:

1. **GET /** — the welcome message. Expand the row, click **Try it out**, then **Execute**. Status code `200` and body `{"message":"Welcome to the Book API"}`.
2. **GET /books** — every book. **Try it out**, then **Execute**. Status code `200`. The body matches the `curl` output in Step 4B, including the string keys `"1"`, `"2"`, and `"3"`.
3. **GET /books/{book_id}** — one book. **Try it out**, set `book_id` to `2`, then **Execute**. Status code `200` and body `{"title":"Frankenstein","author":"Mary Shelley"}`. Run it again with `book_id` set to `99`. Status code `404` and body `{"detail":"Book 99 not found"}`.

## Step 6: Add a book

Leave the server from Step 3 running. `fastapi dev` reloads `src/main.py` when the file is saved.

Do **one** of the two options. Both add a POST `/books` endpoint: the client sends a book as JSON, the function stores it, and the response includes a new id. If this is the first book you add, that id is `4`.

Use your own URL from Step 3 if it is not `http://127.0.0.1:8000`.

In the `curl` commands below, `-X POST` sets the method, `-H` sets the header so FastAPI reads the body as JSON, and `-d` is the JSON object. A `\` at the end of a line continues the command.

### 6A. With Claude Code

If `claude` is not installed yet, follow [Claude Code setup](../../setup/claude-cursor-vscode.md). Start Claude Code in the project folder:

```bash
cd ~/ds2022-fall-2026/my_api
claude
```

The first time in this folder, Claude Code asks whether to trust this folder. Check the path, then choose **Yes**.

Paste this prompt and press Return:

```text
Add a POST endpoint to src/main.py that lets a client add a new book. Store the book in the books dictionary and return it with a new id.
```

Claude shows the edit and asks before it writes the file. Approve the change to `src/main.py`.

At the Claude prompt, `!` runs a shell command and shows you the output. Print the file:

```text
! cat src/main.py
```

Look for a new POST route, `@app.post("/books")`. The details may differ. A typical version defines the two fields with a Pydantic model and returns status `201` (Created):

```python
from pydantic import BaseModel

# Data a client sends to add a book
class Book(BaseModel):
    title: str
    author: str

# Add a new book
@app.post("/books", status_code=201)
def add_book(book: Book):
    book_id = max(books, default=0) + 1
    books[book_id] = book.model_dump()
    return {"id": book_id, **books[book_id]}
```

The JSON keys must be `title` and `author`, the same fields as the model. If either field is missing, FastAPI responds with status `422`.

Wait until the server terminal shows that it reloaded, then send a book. At the Claude prompt, keep the command on one line:

```text
! curl -X POST http://127.0.0.1:8000/books -H "Content-Type: application/json" -d '{"title":"Dracula","author":"Bram Stoker"}'
```

Or, in the second terminal, without `!`:

```bash
curl -X POST http://127.0.0.1:8000/books \
  -H "Content-Type: application/json" \
  -d '{"title": "Dracula", "author": "Bram Stoker"}'
```

Response:

```text
{"id":4,"title":"Dracula","author":"Bram Stoker"}
```

### 6B. Write the endpoint yourself

Open `src/main.py`, add this function at the end, and save. You do not need a new import. `status_code=201` tells FastAPI to answer with `201 Created`.

```python
@app.post("/books", status_code=201)
def add_book(book: dict):
    # create a new id
    new_id = max(books.keys()) + 1
    # add to books dictionary
    books[new_id] = book
    return {"id": new_id, **book}
```

The parameter `book: dict` receives the JSON object from the request body. Send `title` and `author` so the new entry matches the other books.

Wait until the server terminal shows that it reloaded. In the second terminal:

```bash
curl -X POST http://127.0.0.1:8000/books \
  -H "Content-Type: application/json" \
  -d '{"title": "To Kill a Mockingbird", "author": "Harper Lee"}'
```

Response:

```text
{"id":4,"title":"To Kill a Mockingbird","author":"Harper Lee"}
```

### Check the new book

Whichever option you used, list the books:

```bash
curl http://127.0.0.1:8000/books
```

The new book is in the list. Its key is a string, `"4"`, as in Step 4B. The dictionary lives only in memory. Stopping the server drops any book you added. The three books written in `src/main.py` are there again the next time you start the server.

After the reload, **POST /books** also appears at http://127.0.0.1:8000/docs. Click **Try it out** on that row to send the same JSON from the browser.

**Well done. You built your own API.**

## Resources

- [Claude Code setup](../../setup/claude-cursor-vscode.md)
- [Claude Code cheatsheet](../../setup/claude-cheatsheet.png)
- [FastAPI homepage](https://fastapi.tiangolo.com)
- [FastAPI Example](https://fastapi.tiangolo.com/#example)
- [Interactive API docs with Swagger](https://fastapi.tiangolo.com/#interactive-api-docs)
