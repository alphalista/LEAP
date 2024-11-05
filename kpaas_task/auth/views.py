from http.client import responses

from django.core.files.storage import default_storage
from django.http import HttpResponse
import requests
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.middleware.csrf import get_token
from config.settings.base import KAKAO_CLIENT_SECRET, KAKAO_REST_API_KEY

from usr.models import Users

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
            u = {
                'user_id' : email_pk,
                'nickname': ''
            }
            url_dev = 'http://localhost:8080'
            url = 'https://leapbond.com'
            end = '/api/user/'
            requests.post(url + end, data=u, headers=headers)
    # raise Exception

