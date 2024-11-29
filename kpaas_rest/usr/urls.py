from django.urls import path
from .views import UsersViewSet

urlpatterns = [
    path('', UsersViewSet.as_view({
        'get': 'list',
        'post': 'create',
    })),
    path('<str:pk>/', UsersViewSet.as_view({
        'delete': 'destroy',
        'put': 'update',
        'patch': 'partial_update',
    }))
]