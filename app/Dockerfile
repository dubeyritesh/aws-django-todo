FROM python:3.11
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app/
CMD gunicorn todo_app.wsgi:application --bind 0.0.0.0:8000
