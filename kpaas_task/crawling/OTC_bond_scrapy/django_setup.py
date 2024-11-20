import os, sys
import django
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../')))
# Django 프로젝트의 설정 파일 경로 설정
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')  # Django 프로젝트의 settings.py 경로로 대체
django.setup()  # Django 앱 로드