# #!/bin/bash
# set -e
# #!/bin/bash
# exec > >(tee /var/log/user_data.log | logger -t user-data) 2>&1

# # Update & install dependencies
# echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
# sudo apt update -y
# sudo apt install -y python3-pip python3-venv git

# # Clone the Django app
# cd /home/ubuntu
# git clone ${GIT_REPO} app
# cd app/

# # Setup Python virtual environment
# python3 -m venv venv
# source venv/bin/activate
# pip install -r requirements.txt

# # Export and persist environment variables
# cat <<EOF | sudo tee /etc/profile.d/django_env.sh
# export DB_NAME="${DB_NAME}"
# export DB_USER="${DB_USER}"
# export DB_PASS="${DB_PASS}"
# export DB_HOST="${DB_HOST}"
# export STATIC_BUCKET="${STATIC_BUCKET}"
# EOF

# sudo chmod +x /etc/profile.d/django_env.sh
# source /etc/profile.d/django_env.sh

# # Apply Django migrations and collect static files
# python3 manage.py migrate
# python3 manage.py collectstatic --noinput

# # Run Gunicorn
# # nohup gunicorn todo_app.wsgi:application --bind 0.0.0.0:8000 &
# nohup gunicorn todo_app.wsgi:application --bind 0.0.0.0:8000 > /home/ubuntu/gunicorn.log 2>&1 &

#!/bin/bash
exec > >(tee /var/log/user_data.log | logger -t user-data) 2>&1
set -e

sudo apt update -y
sudo apt install -y python3-pip python3-venv git

# Clone the app
cd /home/ubuntu
git clone ${GIT_REPO} app
cd /home/ubuntu/app/app/

# Setup virtual environment
python3 -m venv venv
source venv/bin/activate

# Install requirements
pip install --upgrade pip
pip install -r requirements.txt

# Export env variables
export DB_NAME="${DB_NAME}"
export DB_USER="${DB_USER}"
export DB_PASS="${DB_PASS}"
export DB_HOST="${DB_HOST}"
export STATIC_BUCKET="${STATIC_BUCKET}"

# Migrate and collect static
python3 manage.py migrate
python3 manage.py collectstatic --noinput

# Start gunicorn and redirect logs
nohup gunicorn todo_app.wsgi:application \
  --bind 0.0.0.0:8000 \
  --log-level debug > /home/ubuntu/gunicorn.log 2>&1 &
