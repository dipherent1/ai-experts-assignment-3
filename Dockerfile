FROM python:3.9-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code and tests
COPY . .

# Set PYTHONPATH so python can find the 'app' module
ENV PYTHONPATH=/app

# Run pytest by default
CMD ["python", "-m", "pytest", "-v"]
