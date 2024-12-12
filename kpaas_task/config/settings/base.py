from pathlib import Path
import os
import environ

# 환경 변수 로드
env = environ.Env()

# 기본 경로 설정
BASE_DIR = Path(__file__).resolve().parent.parent.parent

# 기본 환경변수 파일 로드
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

# 보안 키
SECRET_KEY = env('SECRET_KEY')
KAKAO_ADMIN_KEY = env('KAKAO_ADMIN_KEY')
KAKAO_REST_API_KEY = env('KAKAO_REST_API_KEY')
KAKAO_CLIENT_SECRET = env('KAKAO_CLIENT_SECRET')
NAVER_CLIENT_ID = env('NAVER_CLIENT_ID')
NAVER_CLIENT_SECRET = env('NAVER_CLIENT_SECRET')

# 기본 디버그 모드 (세부 설정 파일에서 수정)
DEBUG = True

# 기본 허용 호스트
ALLOWED_HOSTS = ['*']

# 애플리케이션 정의
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
    'usr',
    'rest_framework_simplejwt',
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
        'DIRS': [BASE_DIR / 'templates'],
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

AUTH_USER_MODEL = 'usr.Users'

# Internationalization
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'Asia/Seoul'
USE_I18N = True
USE_TZ = True

# Static 파일 경로
STATIC_URL = 'static/'

# 기본 필드 타입
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


KAKAO_ADMIN_KEY = env('KAKAO_ADMIN_KEY')
KAKAO_REST_API_KEY = env('KAKAO_REST_API_KEY')
KAKAO_CLIENT_SECRET = env('KAKAO_CLIENT_SECRET')


CELERY_RESULT_BACKEND = 'django-db'
CELERY_RESULT_EXTENDED = True
CELERY_TASK_TRACK_STARTED = True

CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_BROKER_CONNECTION_RETRY_ON_STARTUP = True

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTStatelessUserAuthentication',
    )
}

from celery.schedules import crontab

CELERY_BEAT_SCHEDULE = {
    'market_bond_code_task': {
        'task': 'marketbond.tasks.market_bond_code_info',
        'schedule': crontab(minute=0, hour=0),
        'options': {
            'expires': 60 * 5,
            'time_limit': 60 * 40
        }
    },
    'market_bond_issue_info_task': {
        'task': 'marketbond.tasks.market_bond_issue_info',
        'schedule': crontab(minute=5, hour=0),
        'options': {
            'expires': 60 * 60,
            'time_limit': 60 * 40
        }
    },
    'market_bond_inquire_asking_price_task': {
        'task': 'marketbond.tasks.market_bond_inquire_asking_price',
        'schedule': crontab(minute='*/30', hour='9-16'),
        'options': {
            'expires': 60 * 60,
            'time_limit': 60 * 40
        }
    },
    'market_bond_inquire_daily_itemchartprice': {
        'task': 'marketbond.tasks.market_bond_inquire_daily_itemchartprice',
        'schedule': crontab(minute=0, hour=1),
        'options': {
            'expires': 60 * 60,
            'time_limit': 60 * 40
        }
    },
    'market_bond_inquire_price': {
        'task': 'marketbond.tasks.market_bond_inquire_price',
        'schedule': crontab(minute='*/30', hour='9-16'),
        'options': {
            'expires': 60 * 60,
            'time_limit': 60 * 40
        }
    },
    'naver_news_task': {
        'task': 'news.tasks.naver_news',
        'schedule': 60 * 60,
        'options': {
            'expires': 60 * 60
        }
    },
    'crawling': {
        'task': 'crawling.tasks.crawling',
        'schedule': 60 * 2,
        'options': {
            'expires': 60 * 1
        }
    },
    'holding_to_expired': {
        'task': 'crawling.tasks.holding_to_expired',
        'schedule': crontab(minute='0', hour='0'),
        'options': {
            'expires': 60 * 2
        }
    },
    'pre_data_pipeline': {
        'task': 'crawling.tasks.pre_data_pipeline',
        'schedule': crontab(minute='57', hour='23'),
        'options': {
            'expires': 60 * 5
        }
    },
    # 채권 양이 많기 때문에 1시간으로 보고 스케쥴러 설정
    'marketBond_pre_data_pipeline': {
        'task': 'marketbond.tasks.pre_data_pipeline',
        'schedule': crontab(minute='0', hour='23'),
        'options': {
            'expires': 60 * 30
        }
    },
    'OtcBond_trending': {
        'task': 'crawling.tasks.otc_bond_trending_pipeline',
        'schedule': 60 * 5,
        'options': {
            'expires': 60 * 1
        }
    },
    'combine_data': {
        'task': 'marketbond.tasks.combine',
        'schedule': 60 * 30,
        'options': {
            'expires': 60 * 60,
            'time_limit': 60 * 40
        }
    },
    'MarketBond_trending': {
        'task': 'marketbond.tasks.marketbond_trending_pipeline',
        'schedule': 60 * 20,
        'options': {
            'expires': 60 * 10
        }
    }
}

