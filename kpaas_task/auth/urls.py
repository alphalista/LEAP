from django.urls import path
from .views import kakao_callback, NaverCallbackAPIView, NaverUserAPIView
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
    TokenVerifyView,
)

urlpatterns = [
    path('login/kakao-callback', kakao_callback, name='kakao_callback'),
    path('navercb', NaverCallbackAPIView.as_view(), name='navercb'),
    path('naver-user', NaverUserAPIView.as_view(), name='naver-user'),
    path('token', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
]