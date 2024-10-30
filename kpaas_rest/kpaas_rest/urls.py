"""
URL configuration for kpaas_rest project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse

def health_check(request):
    return HttpResponse("OK")

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('', health_check, name='health_check'),  # 쿠버네티스 에러 방지(health 요청, 기본은 root 둘다 필요)
    path('health/', health_check, name='health_check'),  # 쿠버네티스 에러 방지(health 요청, 기본은 root)
    path('admin/', admin.site.urls),
    path('api/', include([
        path('marketbond/', include('marketbond.urls')),
        # path('otcbond/', include("otcbond.urls")),
        path('news/', include("news.urls")),
    ])),
]
