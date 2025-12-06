FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . .

# Remove the hardcoded port. Render will provide $PORT automatically.
ENV PYTHONPATH=/app
ENV HOST=0.0.0.0

# Health check uses $PORT from Render
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT}/health || exit 1

# Run the existing app entrypoint, which launches uvicorn inside app.py
CMD ["python", "app.py"]
