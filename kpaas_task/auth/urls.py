from django.urls import path
from .views import kakao_callback, kakao_refresh, kakao_logout, NaverCallbackAPIView, NaverUserAPIView
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
    TokenVerifyView,
)

urlpatterns = [
    path('login/kakao-callback', kakao_callback, name='kakao_callback'),
    path('login/kakao-refresh', kakao_refresh, name='kakao_refresh'),
    path('login/kakao-logout', kakao_logout, name='kakao_logout'),
    path('navercb', NaverCallbackAPIView.as_view(), name='navercb'),
    path('naver-user', NaverUserAPIView.as_view(), name='naver-user'),
    path('token', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
]