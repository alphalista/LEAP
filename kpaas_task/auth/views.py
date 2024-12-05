from http.client import responses

from django.core.files.storage import default_storage
from django.http import HttpResponse
import requests
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.middleware.csrf import get_token
from config.settings.base import KAKAO_CLIENT_SECRET, KAKAO_REST_API_KEY, NAVER_CLIENT_ID, NAVER_CLIENT_SECRET

import jwt


from usr.models import Users

import requests
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from rest_framework_simplejwt.tokens import RefreshToken, AccessToken
from rest_framework_simplejwt.serializers import TokenObtainSerializer
def kakao_callback(request):
    code = request.GET.get('code')
    redirect_uri = 'http://localhost:3000/auth/login/kakao-callback'
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
            createUser(response.json()['id_token'])
            return JsonResponse(response.json())
        except ValueError:
            return JsonResponse({"error": "Invalid JSON response", "content": response.text}, status=500)
    else:
        return JsonResponse({"response": response.text, "hhhh":data}, status=response.status_code,)

def kakao_refresh(request):
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return JsonResponse({"error": "Missing Authorization Header"}, status=400)
    prefix, refresh_token = auth_header.split(' ')
    if prefix.lower() != 'bearer':
        return JsonResponse({"error": "Invalid Bearer Token"}, status=400)

    headers = {
        'Content-type': 'application/x-www-form-urlencoded;charset=utf-8'
    }
    data = {
        'grant_type': 'refresh_token',
        'client_id': KAKAO_REST_API_KEY,
        'refresh_token': refresh_token,
    }
    response = requests.post('https://kauth.kakao.com/oauth/token', data=data, headers=headers)
    if response.status_code == 200:
        return JsonResponse(response.json())
    return JsonResponse({"response": response.text, "hhhh":data}, status=response.status_code,)

def kakao_logout(request):
    access_token = request.headers.get('Authorization', None)
    headers = {
        'Authorization': access_token,
    }
    response = requests.post('https://kapi.kakao.com/v1/user/unlink', headers=headers)
    if response.status_code == 200:
        return JsonResponse(response.json())
    return JsonResponse({"error": "kakao logout fild", "content": response.text}, status=response.status_code,)



def createUser(id_token):
    headers = {
        'Content-type': 'application/x-www-form-urlencoded;charset=utf-8'
    }
    data = {
        'id_token': id_token,
    }
    response = requests.post('https://kauth.kakao.com/oauth/tokeninfo', data=data, headers=headers)
    if response.status_code == 200:
        # 여기서부터 유저를 만들면 됨
        payload = jwt.decode(id_token, options={"verify_signature": False})

        sub = payload['sub']
        email = payload['email']

        instance = Users.objects.filter(user_id=sub)
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
                user_id=sub,
                email=email,
                nickname='',
            )
    # raise Exception

class NaverLogin:
    def __init__(self, code=None, state=None):
        self.code = code
        self.state = state
        self.token_url = 'https://nid.naver.com/oauth2.0/token'
        self.me_url = 'https://openapi.naver.com/v1/nid/me'
        self.data = {
            'client_id': NAVER_CLIENT_ID,
            'client_secret': NAVER_CLIENT_SECRET,
        }

    def issue_token(self):
        self.data['grant_type'] = 'authorization_code'
        self.data['code'] = self.code
        self.data['state'] = self.state
        response = requests.post(self.token_url, data=self.data)
        print(response.json())
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

class NaverUserManager:
    def __init__(self, access_token, refresh_token):
        self.access_token = access_token
        self.refresh_token = refresh_token

    def validate_token(self):
        headers = {
            'Authorization': 'Bearer ' + self.access_token,
        }
        response = requests.get('https://openapi.naver.com/v1/nid/me', headers=headers)
        data = response.json()
        if data['message'] == 'success':
            return True
        else:
            return False

    def get_user_info(self):
        headers = {
            'Authorization': 'Bearer ' + self.access_token,
        }
        response = requests.get('https://openapi.naver.com/v1/nid/me', headers=headers)
        data = response.json()
        return data

    def create_user(self):
        data = self.get_user_info()
        if data['message'] == 'success':
            res = data['response']
            id = res['id']
            email_pk = res['email']
            profile_image = res['profile_image']
            name = res['name']

            # instance = User.objects.filter(username=email_pk).first()
            # if not instance:
            #     instance = User.objects.create(
            #         username=email_pk
            #     )
            #     instance.set_unusable_password()
            #     instance.save()
                # profile = Profile.objects.create(user=instance, name=name)
                # profile.save()
            tkn_manager = DrfToken()
            # access_token, refresh_token = tkn_manager.create_token(user=instance)

            # return {'access_token': access_token, 'refresh_token': refresh_token}

        return None


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
        lg = NaverLogin(code, state)
        data = lg.issue_token()
        print(data)
        user_manager = NaverUserManager(data['access_token'], data['refresh_token'])
        res = user_manager.create_user()
        return JsonResponse(res)

class NaverUserAPIView(APIView):
    # get token
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

        # refresh token
    def put(self, request, *args, **kwargs):
        access_token = request.GET.get('access_token', None)
        refresh_token = request.GET.get('refresh_token', None)
        if access_token is None:
            access_token = request.GET.get('access_token', None)
        headers = {
            'Authorization': 'Bearer ' + access_token,
        }
        lg = NaverLogin()
        data = lg.refresh_token(refresh_token)
        access_token = data['access_token']

    # delete token
    def delete(self, request, *args, **kwargs):
        access_token = request.GET.get('access_token', None)
        if access_token is None:
            access_token = request.GET.get('access_token', None)
        headers = {
            'Authorization': 'Bearer ' + access_token,
        }
        response = requests.delete('https://openapi.naver.com/v1/nid/me', headers=headers)



class DrfToken:
    def __init__(self):
        pass

    def create_token(self, user):
        token = RefreshToken.for_user(user)
        refresh_token = str(token)
        access_token = str(token.access_token)
        return access_token, refresh_token