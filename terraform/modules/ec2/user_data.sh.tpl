#!/bin/bash
sudo apt update -y
sudo apt install -y python3-pip python3-venv git

# Clone Django app
cd /home/ubuntu
git clone ${GIT_REPO} app
cd app/app/

# Set environment variables
echo "export DB_NAME=${DB_NAME}"       >> ~/.bashrc
echo "export DB_USER=${DB_USER}"       >> ~/.bashrc
echo "export DB_PASS=${DB_PASS}"       >> ~/.bashrc
echo "export DB_HOST=${DB_HOST}"       >> ~/.bashrc
echo "export STATIC_BUCKET=${STATIC_BUCKET}" >> ~/.bashrc
source ~/.bashrc

# Create virtualenv & install dependencies
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Apply migrations & collect static
python manage.py migrate
python manage.py collectstatic --noinput

# Run gunicorn
nohup gunicorn todo_app.wsgi:application --bind 0.0.0.0:8000 &
