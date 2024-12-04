from django.test import TestCase
import requests
from usr.models import Users
import json
# Create your tests here.

class TestUser(TestCase):
    id_token = 'eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJlNmYyYjJhOGExNTFhMWNmN2FkNmRhMzQ5MTg5OTdmNSIsInN1YiI6IjM3ODAyNDc5MzQiLCJhdXRoX3RpbWUiOjE3MzMzMjMwMDksImlzcyI6Imh0dHBzOi8va2F1dGgua2FrYW8uY29tIiwiZXhwIjoxNzMzMzQ0NjA5LCJpYXQiOjE3MzMzMjMwMDksImVtYWlsIjoieXRrMDMwMzA1QG5hdmVyLmNvbSJ9.VL4AV98UL5FbgncEkGr_uVDiNhjtEchV58a_yoResmoHrM_7DKIqJ0xtHN_kMdC2B2lLp8WQ7OEqXp-M73coFZXwgbV9wVtN6HCkORQ_rqSnoAcFb0O7hFE97T9UVMBy0vZU_t2_A4J0-7YM_r5MKPANMkXfFQ13bUyCYLhp7V0eK3TRDTaneQPKBJn1wZNtWjNiCgrEjY3hABdwCANaNAR_ACs8gonMeYg7aGxrEA5un-gKnhK6D6rGF9OpSXWuxg9AOPGLwcxl9WcWeEJy4iUYOsrnXXrhIidljDJ5HDvQQqxMITwTL8jlEUwi0PVKVUIEtW1-aM17Nsr3CLVW3g'
    Authorization_header = {'HTTP_Authorization': 'Bearer ' + id_token}
    @classmethod
    def setUpTestData(cls):
        headers = {
            'Content-type': 'application/x-www-form-urlencoded;charset=utf-8'
        }
        data = {
            'id_token': TestUser.id_token,
        }
        response = requests.post('https://kauth.kakao.com/oauth/tokeninfo', data=data, headers=headers)
        sub = response.json().get('sub')
        email = response.json().get('email')
        # print('sub:', sub, 'email', email)
        Users.objects.create(
            user_id=sub,
            email=email,
            nickname='',
        )
    def test_UserInfo(self):
        self.assertNotEqual(Users.objects.all().count(), 0)

    def test_userNickname(self):
        # 닉네임 생성 테스트
        headers = self.Authorization_header
        data = {
            'nickname': 'test'
        }
        response = self.client.put(path='/api/user/', content_type='application/json', data=json.dumps(data), **headers)
        self.assertEqual(response.status_code, 200)
    def test_userNewsKeyword(self):
        # get 요청
        headers = self.Authorization_header
        response = self.client.get('/api/news/searchKeyword/', **headers)
        self.assertEqual(response.status_code, 200)
        # post 요청
        data = {
            'search_keyword': '채권'
        }
        response = self.client.post('/api/news/searchKeyword/', data=json.dumps(data), content_type='application/json', **headers)
        self.assertEqual(response.status_code, 201)
        response = self.client.delete('/api/news/searchKeyword/1/', content_type='application/json', **headers)
        self.assertEqual(response.status_code, 204)