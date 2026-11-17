# Accessing an API with Python

`weather.py` sends a request to the [Open-Meteo](https://open-meteo.com/) forecast API and prints the current temperature and wind speed in Charlottesville as JSON. The API needs no key.

Run it with [uv](https://docs.astral.sh/uv/):

```bash
uv run weather.py
```

uv reads the dependencies listed at the top of the script, installs `requests` in a temporary environment, and runs the program. You don't need to create a virtual environment or run `pip install`.
