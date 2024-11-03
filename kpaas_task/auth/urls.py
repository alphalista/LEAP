from django.urls import path
from .views import kakao_callback

urlpatterns = [
    path('login/kakao-callback', kakao_callback, name='kakao_callback'),
    # path('seongmin', seongmin, name='seongmin'),
]