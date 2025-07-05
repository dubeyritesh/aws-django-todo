import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
SECRET_KEY = 'your-secret-key'
DEBUG = False
ALLOWED_HOSTS = ['*']
# Change ALLOWED_HOSTS value to below once you get below values and testing done
# ALLOWED_HOSTS = ['your-app.example.com', 'ALB-DNS-HERE.amazonaws.com']


INSTALLED_APPS = [
    'django.contrib.admin', 'django.contrib.auth',
    'django.contrib.contenttypes', 'django.contrib.sessions',
    'django.contrib.messages', 'django.contrib.staticfiles',
    'tasks', 'storages'
]

MIDDLEWARE = ['django.middleware.security.SecurityMiddleware',
              'django.contrib.sessions.middleware.SessionMiddleware',
              'django.middleware.common.CommonMiddleware',
              'django.middleware.csrf.CsrfViewMiddleware',
              'django.contrib.auth.middleware.AuthenticationMiddleware',
              'django.contrib.messages.middleware.MessageMiddleware',
              'django.middleware.clickjacking.XFrameOptionsMiddleware']

ROOT_URLCONF = 'todo_app.urls'
TEMPLATES = [{'BACKEND': 'django.template.backends.django.DjangoTemplates',
              'DIRS': [BASE_DIR/'templates'],
              'APP_DIRS': True,
              'OPTIONS': {'context_processors': [
                  'django.template.context_processors.debug',
                  'django.template.context_processors.request',
                  'django.contrib.auth.context_processors.auth',
                  'django.contrib.messages.context_processors.messages']}}]
WSGI_APPLICATION = 'todo_app.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DB_NAME'),
        'USER': os.getenv('DB_USER'),
        'PASSWORD': os.getenv('DB_PASS'),
        'HOST': os.getenv('DB_HOST'),
        'PORT': '5432',
    }
}

# DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3StaticStorage'
# AWS_STORAGE_BUCKET_NAME = os.getenv('STATIC_BUCKET')
# AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'
# STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/'
# STATIC_ROOT = BASE_DIR / 'static'

# --- STATIC & S3 CONFIG ---
DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
# Optional if needed:
# STATICFILES_STORAGE = 'storages.backends.s3boto3.S3StaticStorage'

AWS_STORAGE_BUCKET_NAME = os.getenv('STATIC_BUCKET')
AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'
STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/'
STATIC_ROOT = BASE_DIR / 'static'


LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
# USE_I18N = USE_L10N = USE_TZ = True
USE_I18N = True
USE_TZ = True

