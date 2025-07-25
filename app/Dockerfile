# FROM python:3.11
# WORKDIR /app
# COPY requirements.txt /app/
# RUN pip install --no-cache-dir -r requirements.txt
# COPY . /app/
# CMD gunicorn todo_app.wsgi:application --bind 0.0.0.0:8000

# Dockerfile
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

COPY . .

# Collect static files and run migrations on container start
CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn todo_app.wsgi:application --bind 0.0.0.0:8000"]
