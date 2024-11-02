"""
Django settings for config project.

Generated by 'django-admin startproject' using Django 5.1.1.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/5.1/ref/settings/
"""

from pathlib import Path
import os
import environ

env = environ.Env()

environ.Env.read_env(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), '.env'))

KAKAO_ADMIN_KEY = env('KAKAO_ADMIN_KEY')
KAKAO_REST_API_KEY = env('KAKAO_REST_API_KEY')
KAKAO_CLIENT_SECRET = env('KAKAO_CLIENT_SECRET')

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-obbj^l@u^(c$8lk&+t&mq9r-q$p1aw%v#*yx#d&sk_-23g$4_v'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = [
    'daphne',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'extract',
    'marketbond',
    'news',
    'rest_framework',
    'django_filters',
    'django_celery_beat',
    'django_celery_results',
    'crawling',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates']
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'

ASGI_APPLICATION = 'config.asgi.application'



# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


# Password validation
# https://docs.djangoproject.com/en/5.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'Asia/Seoul'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/

STATIC_URL = 'static/'

# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


CELERY_RESULT_BACKEND = 'django-db'
CELERY_RESULT_EXTENDED = True

CELERY_BROKER_URL = 'redis://localhost:6379'
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_WORKER_POOL = 'solo'  # 윈도우 에러 해결
CELERY_BROKER_CONNECTION_RETRY_ON_STARTUP = True

from celery.schedules import crontab

CELERY_BEAT_SCHEDULE = {
    'market_bond_code_task': {
        'task': 'marketbond.tasks.market_bond_code_info',
        'schedule': crontab(minute=0, hour=0),
        'options': {
            'expires': 60 * 5
        }
    },
    'market_bond_issue_info_task': {
        'task': 'marketbond.tasks.market_bond_issue_info',
        'schedule': crontab(minute=5, hour=0),
        'options': {
            'expires': 60 * 19
        }
    },
    'market_bond_inquire_asking_price_task': {
        'task': 'marketbond.tasks.market_bond_inquire_asking_price',
        'schedule': crontab(minute='*/30', hour='9-16'),
        'options': {
            'expires': 60 * 19
        }
    },
    'market_bond_inquire_daily_itemchartprice': {
        'task': 'marketbond.tasks.market_bond_inquire_daily_itemchartprice',
        'schedule': crontab(minute=30, hour=0),
        'options': {
            'expires': 60 * 19
        }
    },
    'naver_news_task': {
        'task': 'news.tasks.naver_news',
        'schedule': 60 * 15,
        'options': {
            'expires': 60 * 14
        }
    },
    'crawling': {
        'task': 'crawling.tasks.crawling',
        'schedule': 60 * 2,
        'options': {
            'expires': 60 * 1
        }
    },
}

# late expire