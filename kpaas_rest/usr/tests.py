from django.test import TestCase
import requests
from usr.models import Users
import json
# Create your tests here.

class TestUser(TestCase):
    id_token = 'eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJlNmYyYjJhOGExNTFhMWNmN2FkNmRhMzQ5MTg5OTdmNSIsInN1YiI6IjM3ODAyNDc5MzQiLCJhdXRoX3RpbWUiOjE3MzMxMTg4MTUsImlzcyI6Imh0dHBzOi8va2F1dGgua2FrYW8uY29tIiwiZXhwIjoxNzMzMTQwNDE1LCJpYXQiOjE3MzMxMTg4MTUsImVtYWlsIjoieXRrMDMwMzA1QG5hdmVyLmNvbSJ9.SI18Ji0XHh26AhT9YOJvjDbw6FSOlbtw6cf-uUSfsaR1LeXbb8s4zEm4SbV3yDcVjx1ZrHfmQhCFDPppaMVoogXPE-osh9oSY0K6qPbtM4jLDJimai1vFpaWcx5zcJQynkBm_YCdeizE4RihQA0tY3H-sCHaEnOJvDs8UZWAwGyl9bt4X3IxTYk5qEftPRwiQCB0dCiWZHPxNp4bAxWMlU32XjVKw_UnsammWQKx4X1czeFUmeW7qKXffrfa3653rPwlaJ0t2E3DQh5hoKy-rnSgbxXbv4mpbOyIq6lTYER8jCD9Mq1xF-1swztMOeOwgmwtlzC8PEfBpO8Ix0ybKA'
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