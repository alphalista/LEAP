from django.test import TestCase
from config.settings.base import KAKAO_CLIENT_SECRET, KAKAO_REST_API_KEY
from django.test.utils import override_settings
import requests

from usr.models import Users
from .views import createUser

# Create your tests here.
@override_settings(DJANGO_SETTINGS_MODULE="config.settings.production")
class CreateUserTestCase(TestCase):
    def test_users(self):
        # code는 매번 실행시마다 바꿔줍니다.
        code = "2bXKqZ6SsytmUaZP73vHq6rLmbpdg5cwtywYl7eJLRsqwaYLFwaDdAAAAAQKPCRaAAABk5byhTeSBpCp5rpDbg"
        redirect_uri = 'http://localhost:3000/auth/login/kakao-callback'
        url = 'https://kauth.kakao.com/oauth/token'

        headers = {
            'Content-type': 'application/x-www-form-urlencoded;charset=utf-8'
        }

        data = {
            'grant_type': 'authorization_code',
            'client_id': KAKAO_REST_API_KEY,
            'redirect_uri': redirect_uri,
            'code': code,
            'client_secret': KAKAO_CLIENT_SECRET
        }
        # 외부 요청 허용
        response = requests.post(url, data=data, headers=headers)
        # print(response.json())
        self.assertEqual(response.status_code, 200) # 정상적으로 리다이렉트 됐는지 판단

        createUser(response.json().get('id_token'))
        self.assertNotEqual(Users.objects.all().count(), 0) # 유저가 생성되었는가

