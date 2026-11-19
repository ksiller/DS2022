# Testing Python code

Tests verify that your code produces the expected results for known inputs. Small, focused tests help you catch errors early, change code with confidence, and confirm that each step of a data pipeline works independently.

## Check functions with `assert`

A function check calls one function with a small, fixed input and compares the result with the expected value. If the comparison is false, `assert` raises an `AssertionError` and identifies the failed check. The following example tests two transformations from the bookstore example.

`src/pipeline.py`:

```python
def transaction_total(quantity, unit_price):
    return round(quantity * unit_price, 2)


def remove_duplicates(rows):
    seen, unique = set(), []
    for row in rows:
        if row["transaction_id"] not in seen:
            seen.add(row["transaction_id"])
            unique.append(row)
    return unique
```

`tests/check_pipeline.py`:

```python
from pipeline import transaction_total, remove_duplicates


def test_transaction_total():
    assert transaction_total(2, 15.00) == 30.00


def test_remove_duplicates():
    rows = [{"transaction_id": "A003"}, {"transaction_id": "A003"}]
    expected = [{"transaction_id": "A003"}]
    assert remove_duplicates(rows) == expected


test_transaction_total()
test_remove_duplicates()
print("All checks passed")
```

Run the checks inside the container. Replace `IMAGE` with your image name:

```bash
docker run --rm --entrypoint python IMAGE tests/check_pipeline.py
```

If both checks pass, Python prints `All checks passed`. If either check fails, the script stops at that `assert`, reports an `AssertionError`, and does not print the success message.

For this example to work:

- **Write the pipeline as functions.** Each check must be able to call one step with its own input. Code that runs entirely at the top level is difficult to test in isolation.
- **Copy the checks into the image.** Add `COPY tests/ ./tests/` to the Dockerfile after `COPY src/ ./src/`.
- **Make the source importable.** Add `ENV PYTHONPATH=/app/src` to the Dockerfile. Python can then resolve `from pipeline import ...` to `src/pipeline.py`.
- **Handle floating-point comparisons carefully.** For currency, round to the required number of decimal places before comparing. More generally, use `math.isclose()` or `pytest.approx()` for approximate comparisons.
- **Use discoverable test names.** Because the functions start with `test_`, pytest can discover them automatically. If pytest is installed in the image, run them with `pytest tests/`.

> Use `assert` in checks and tests—not for validating production input. Python can disable assertions when it runs with optimization enabled.

## Resources

- [Python's `assert`: Debug and Test Your Code Like a Pro](https://realpython.com/python-assert-statement/)