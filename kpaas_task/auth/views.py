from django.http import HttpResponse
import requests
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.middleware.csrf import get_token
from config.settings.base import KAKAO_CLIENT_SECRET, KAKAO_REST_API_KEY

def kakao_callback(request):
    code = request.GET.get('code')
    redirect_uri = 'http://127.0.0.1:8000/auth/login/kakao-callback'
    url = 'https://kauth.kakao.com/oauth/token'
    test_uri = 'http://127.0.0.1:8000/auth/seongmin'
    csrf_token = get_token(request)
    
    key = KAKAO_REST_API_KEY

    headers = {
        'Content-type': 'application/x-www-form-urlencoded;charset=utf-8'
    }

    test_headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRFToken': csrf_token
    }

    data = {
        'grant_type' : 'authorization_code',
        'client_id' : key,
        'redirect_uri' : redirect_uri,
        'code' : code,
        'client_secret' : KAKAO_CLIENT_SECRET
        }
    
    response = requests.post(url, data=data, headers=headers)
    
    if response.status_code == 200:
        try:
            # post_response = requests.post(test_uri, headers=test_headers, data={"message": "hi"})
            return JsonResponse(response.json())
        except ValueError:
            return JsonResponse({"error": "Invalid JSON response", "content": response.text}, status=500)
    else:
        return JsonResponse({"response": response.text, "hhhh":data}, status=response.status_code,)

# def seongmin(request):
#     print("hi")