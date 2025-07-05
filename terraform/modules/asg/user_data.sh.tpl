#!/bin/bash
sudo apt update -y
sudo apt install -y python3-pip python3-venv git

cd /home/ubuntu
git clone ${GIT_REPO} app
cd app/app/

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

export DB_NAME=${DB_NAME}
export DB_USER=${DB_USER}
export DB_PASS=${DB_PASS}
export DB_HOST=${DB_HOST}
export STATIC_BUCKET=${STATIC_BUCKET}

python manage.py migrate
python manage.py collectstatic --noinput

nohup gunicorn todo_app.wsgi:application --bind 0.0.0.0:8000 &
