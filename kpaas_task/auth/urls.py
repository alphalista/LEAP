from django.urls import path
from .views import kakao_callback, NaverCallbackAPIView, NaverUserAPIView


urlpatterns = [
    path('login/kakao-callback', kakao_callback, name='kakao_callback'),
    path('navercb', NaverCallbackAPIView.as_view(), name='navercb'),
    path('naver-user', NaverUserAPIView.as_view(), name='naver-user'),

]