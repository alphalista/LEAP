from http.client import responses

from django.core.files.storage import default_storage
from django.http import HttpResponse
import requests
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.middleware.csrf import get_token
from config.settings.base import KAKAO_CLIENT_SECRET, KAKAO_REST_API_KEY, NAVER_CLIEND_ID, NAVER_CLIENT_SECRET

from usr.models import Users

import requests
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
def kakao_callback(request):
    code = request.GET.get('code')
    redirect_uri = 'http://127.0.0.1:8000/auth/login/kakao-callback'
    url = 'https://kauth.kakao.com/oauth/token'
    
    headers = {
        'Content-type': 'application/x-www-form-urlencoded;charset=utf-8'
    }

    data = {
        'grant_type' : 'authorization_code',
        'client_id' : KAKAO_REST_API_KEY,
        'redirect_uri' : redirect_uri,
        'code' : code,
        'client_secret' : KAKAO_CLIENT_SECRET
        }
    
    response = requests.post(url, data=data, headers=headers)
    
    if response.status_code == 200:
        try:
            # ID 토큰 인증을 토대로 다시 요청
            createUser(response.json().get('id_token'))
            return JsonResponse(response.json())
        except ValueError:
            return JsonResponse({"error": "Invalid JSON response", "content": response.text}, status=500)
    else:
        return JsonResponse({"response": response.text, "hhhh":data}, status=response.status_code,)


def createUser(id_token):
    headers = {
        'Content-type': 'application/x-www-form-urlencoded;charset=utf-8'
    }
    data = {
        'id_token' : id_token,
    }
    response = requests.post('https://kauth.kakao.com/oauth/tokeninfo', data=data, headers=headers)
    if response.status_code == 200:
        # 여기서부터 유저를 만들면 됨
        email_pk = response.json().get('email')
        instance = Users.objects.filter(user_id=email_pk)
        if not instance:
            # u = {
            #     'user_id' : email_pk,
            #     'nickname': ''
            # }
            # url_dev = 'http://localhost:8080'
            # url = 'https://leapbond.com'
            # end = '/api/user/'
            # requests.post(url + end, data=u, headers=headers)
            Users.objects.create(
                user_id=email_pk,
                nickname=''
            )
    # raise Exception

class NaverLogin:
    def __init__(self, code, state):
        self.code = code
        self.state = state
        self.token_url = 'https://nid.naver.com/oauth2.0/token'
        self.me_url = 'https://openapi.naver.com/v1/nid/me'
        self.data = {
            'client_id': NAVER_CLIEND_ID,
            'client_secret': NAVER_CLIENT_SECRET,
        }

    def issue_token(self):
        self.data['grant_type'] = 'authorization_code'
        self.data['code'] = self.code
        self.data['state'] = self.state
        response = requests.post(self.token_url, data=self.data)

        if response.status_code == 200:
            data = response.json()
            return data
        else:
            return {'error': response.status_code}

    def refresh_token(self, refresh_token):
        self.data['grant_type'] = 'refresh_token'
        self.data['refresh_token'] = refresh_token
        response = requests.post(self.token_url, data=self.data)

        if response.status_code == 200:
            data = response.json()
            return data
        else:
            return {'error': response.status_code}

    def delete_token(self, access_token):
        self.data['grant_type'] = 'delete'
        self.data['access_token'] = access_token
        self.data['service_provider'] = 'NAVER'
        response = requests.post(self.token_url, data=self.data)

        if response.status_code == 200:
            data = response.json()
            return data
        else:
            return {'error': response.status_code}



# Naver LoginURL
# uri = "https://nid.naver.com/oauth2.0/authorize"
# data = {
#     'response_type': 'code',
#     'client_id': NAVER_CLIEND_ID,
#     'redirect_uri': 'http://leapbond.com/auth/navercb',
#     'state': 'test',
# }

class NaverCallbackAPIView(APIView):
    def get(self, request, *args, **kwargs):
        code = request.GET.get('code', None)
        state = request.GET.get('state', None)
        print(code, state)
        lg = NaverLogin(code, state)
        data = lg.issue_token()

        return JsonResponse(data)

class NaverUserAPIView(APIView):
    def get(self, request, *args, **kwargs):
        access_token = request.GET.get('access_token', None)
        if access_token is None:
            access_token = request.GET.get('access_token', None)
        headers = {
            'Authorization': 'Bearer ' + access_token,
        }
        response = requests.get('https://openapi.naver.com/v1/nid/me', headers=headers)
        data = response.json()
        return JsonResponse(data)