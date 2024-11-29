import jwt
from django.conf import settings
from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
from .models import Users

class CustomJWTAuthentication(BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.headers.get('Authorization')
        if not auth_header:
            return None
        try:
            prefix, token = auth_header.split(' ')
            if prefix.lower() != 'bearer':
                raise AuthenticationFailed('Invalid token prefix')

        except jwt.ExpiredSignatureError:
            raise AuthenticationFailed('Token expired')
        except jwt.InvalidTokenError:
            raise AuthenticationFailed('Invalid token')

        try:
            payload = jwt.decode(token, options={"verify_signature": False})
            sub = payload['sub']
            user = Users.objects.get(user_id=sub)
        except Users.DoesNotExist:
            raise AuthenticationFailed('User not found')

        return user, token

    def authenticate_header(self, request):
        return 'Bearer'

