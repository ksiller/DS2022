# APIs

An **API** (application programming interface) is a way for one program to request data, or an action, from another. In this exercise the other program is a small web server you run on your own computer with [FastAPI](https://fastapi.tiangolo.com). A client — your browser, the `curl` command, or another script — sends an HTTP request to a URL. A Python function handles that request and returns a dictionary. FastAPI converts the dictionary to JSON and sends it back.

You will build a Book API: a welcome message, the list of books, and one book looked up by its id. You will call those endpoints from the terminal, try the same calls in the automatic documentation page, and add an endpoint that creates a new book.


## Step 1: Setup

```bash
mkdir -p ~/ds2022-fall-2026/api
cd ~/ds2022-fall-2026/api
uv init my_api
cd my_api
```

Add the `fastapi` package.
```bash
uv add "fastapi[standard]"
```


## Step 2: Create an API

`uv init` already created `main.py`. Replace its contents with:

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
- The function returns a Python dictionary, which FastAPI automatically converts to JSON.

| FastAPI decorator | HTTP method | Purpose |
|---|---|---|
| `@app.get()` | GET | Retrieve books |
| `@app.post()` | POST | Add a new book |
| `@app.put()` | PUT | Update a book |
| `@app.delete()` | DELETE | Delete a book |

## Step 3: Start the API

```bash
uv run fastapi dev main.py
```

This starts your FastAPI server, typically at http://127.0.0.1:8000. Your address and port may differ. Use the URL printed in the server output for the commands below. Leave this terminal running.

## Step 4: Test the API

Open a new terminal. You can access the API with a browser, `curl`, or Python.

**A. Welcome message**

```bash
curl http://127.0.0.1:8000/
```

Response:

```text
{"message":"Welcome to the Book API"}
```

**B. Retrieve all books**

The route in `main.py` is `/books`, with no slash at the end. **Do not add a trailing `/`; `/books/` is a different path and FastAPI answers that path with a redirect and an empty body.** 

```bash
curl http://127.0.0.1:8000/books
```

Response (`curl` prints this on one line):

```text
{"1":{"title":"Pride and Prejudice","author":"Jane Austen"},"2":{"title":"Frankenstein","author":"Mary Shelley"},"3":{"title":"Moby Dick","author":"Herman Melville"}}
```

JSON object keys are strings, so the ids appear in quotes (`"1"`, `"2"`, `"3"`) even though the Python dictionary uses integers.

**C. Retrieve one book**

```bash
curl http://127.0.0.1:8000/books/2
```

Response:

```text
{"title":"Frankenstein","author":"Mary Shelley"}
```

## Step 5: Explore automatic API documentation

FastAPI builds a description of your API from the code: each path, HTTP method, parameter, and response. [Swagger UI](https://github.com/swagger-api/swagger-ui) is a web page that turns that description into a form. You pick an endpoint, fill in any parameters, and send a real request to the server from Step 3. The page shows the status code and the JSON body. The same description is available as JSON at http://127.0.0.1:8000/openapi.json. Swagger UI is the readable page for that file.

**Open:** http://127.0.0.1:8000/docs

Update the address if your API runs at a different address or port.

Each endpoint is a row. Click the row to expand it, click **Try it out**, fill in parameters if the row has any, then click **Execute**.

Try these three:

1. **GET /** — the welcome message. Expand the row, click **Try it out**, then **Execute**. Status code `200` and body `{"message":"Welcome to the Book API"}`.
2. **GET /books** — every book. **Try it out**, then **Execute**. Status code `200`. The body matches the `curl` output in Step 4B, including the string keys `"1"`, `"2"`, and `"3"`.
3. **GET /books/{book_id}** — one book. **Try it out**, set `book_id` to `2`, then **Execute**. Status code `200` and body `{"title":"Frankenstein","author":"Mary Shelley"}`. Run it again with `book_id` set to `99`. Status code `404` and body `{"detail":"Book 99 not found"}`.

## Step 6: Create a new endpoint to add a book

### Option 1: add another endpoint with Claude
```bash
cd ~/ds2022-fall-2026/api/my_api # ensure you're in the project folder
# launch claude
claude
```

Add this prompt and press Enter/Return.
```text
add another endpoint to main.py that allows upload of a new book
```

In the Claude terminal, enter:
```bash
! cat main.py
```
The `!` allows you to run any shell command through Claude, in this case we use `cat` to print the updated main.py file.

Look for a new function with the decorator `@app.post("/books", status_code=201)`

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

**Test it:**

In Claude terminal,
```bash
! curl -X POST localhost:8000/books -H "Content-Type: application/json" -d
  '{"title":"Dracula","author":"Bram Stoker"}'
```

Or in regular Terminal without `!`
```bash
curl -X POST localhost:8000/books -H "Content-Type: application/json" -d
  '{"title":"Dracula","author":"Bram Stoker"}'
```

**Note:** Your main.py script defines the fields `title` and `author` so the json object you're passing must use the same field names.

### Option B: add the endpoint yourself

Open main.py and add this function at the end of the script and save it.

```python
@app.post("/books", status_code=201)
def add_book(book: dict):
    # create a new id
    new_id = max(books.keys()) + 1
    # add to books dictionary
    books[new_id] = book
    return {"id": new_id, **book}
```

**Test it:**

```bash
curl -X POST localhost:8000/books -H "Content-Type: application/json" -d
  '{"title":"Dracula","author":"Bram Stoker"}'
```


## Resources

- [Claude Installation](../../setup/claude-cursor-vscode.md)
- [Claude](../../setup/claude-cheatsheet.png) 
- [FastAPI homepage](https://fastapi.tiangolo.com)
- [FastAPI Example](https://fastapi.tiangolo.com/#example)
- [Interactive API docs with Swagger](https://fastapi.tiangolo.com/#interactive-api-docs)


