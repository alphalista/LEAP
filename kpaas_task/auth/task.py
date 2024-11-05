from pathlib import Path
import environ
import os
import requests

env = environ.Env()
environ.Env.read_env(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), '.env'))

BASE_DIR = Path(__file__).resolve().parent.parent.parent
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

KAKAO_CLIENT_SECRET = env('KAKAO_CLIENT_SECRET')
KAKAO_REST_API_KEY = env('KAKAO_REST_API_KEY')
KAKAO_ADMIN_KEY = env('KAKAO_ADMIN_KEY')

def get_kakao_token():
    try:
        kakao_oauth_url = "https://kauth.kakao.com/oauth/authorize"
        client_id = KAKAO_REST_API_KEY
        redirect_uri = "http://localhost:3000/auth/login/kakao-callback"

        token_data = {
            "client_id": client_id,
            "redirect_uri": redirect_uri,
            "code": "code"
        }

        token_response = requests.post(kakao_oauth_url, token_data)
        token_json = token_response.json()

        print(token_json)

    except:
        pass

if __name__ == "__main__":
    get_kakao_token()