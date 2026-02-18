# AI Software Engineer Assignment

This repository contains a simple Python HTTP Client implementation and its associated test suite.

## Project Structure

- `app/`: Contains the source code (`http_client.py`, `tokens.py`).
- `tests/`: Contains the test suite (`test_http_client.py`).
- `Dockerfile`: Configuration for running tests in a container.
- `requirements.txt`: Pinned dependencies.

## How to Run Tests Locally

1. **Install Dependencies**
   It is recommended to use a virtual environment.

   ```bash
   pip install -r requirements.txt
   ```

2. **Run Pytest**
   ```bash
   pytest -v
   ```

## How to Build and Run with Docker

1. **Build the Image**
   Run this command in the root directory:

   ```bash
   docker build -t python-assignment .
   ```

2. **Run the Tests**
   This container runs the tests automatically upon startup:
   ```bash
   docker run --rm python-assignment
   ```
