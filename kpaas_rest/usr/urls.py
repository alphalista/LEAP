from django.urls import path
from .views import UserViewSet

urlpatterns = [
    path('', UserViewSet.as_view({
        'get': 'list',
        'post': 'create',
    })),
    path('<str:pk>/', UserViewSet.as_view({
        'delete': 'destroy',
        'put': 'update',
        'patch': 'partial_update',
    }))
]