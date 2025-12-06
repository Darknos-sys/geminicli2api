FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Render will set PORT automatically
ENV PYTHONPATH=/app
ENV HOST=0.0.0.0

# Do NOT hardcode PORT
# ENV PORT=7860   <-- remove this

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT}/health || exit 1

# Use uvicorn directly, respect Render's PORT
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port $PORT"]
