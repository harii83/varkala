# 1. Use the latest stable Python for 2026
FROM python:3.12-slim

# 2. Set environment variables
# Prevents Python from writing .pyc files and ensures logs are sent to the terminal
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Set work directory
WORKDIR /app/varkala

# 4. Install system dependencies for Postgres and Oscar
# Oscar often needs 'build-essential' for some of its dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    libpq-dev \
    build-essential \
    gettext \
    && rm -rf /var/lib/apt/lists/*

# 5. Install Python dependencies
# Upgrade pip first to handle modern packages
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# 6. Copy the rest of the project code
COPY . .

# 7. Expose the Django port
EXPOSE 8000

# 8. Start the application
# Using 0.0.0.0 is mandatory for Docker to route traffic into the container
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
