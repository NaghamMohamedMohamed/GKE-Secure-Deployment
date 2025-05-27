# Use a slim Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install required system dependencies for building Python packages and SSL support
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*
 
# Copy requirements and install dependencies
COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app source
COPY . .

# Expose the port ( 8000 )
EXPOSE 8000

# Set default environment values
ENV ENVIRONMENT=DEV \
    HOST=localhost \
    PORT=8000 \
    REDIS_HOST=localhost \
    REDIS_PORT=6379 \
    REDIS_DB=0

# Start the application
CMD ["python", "hello.py"]
