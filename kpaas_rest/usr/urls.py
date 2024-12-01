from django.urls import path
from .views import UsersViewSet

urlpatterns = [
    path('', UsersViewSet.as_view({
        'get': 'list',
        'post': 'create',
        'put': 'update',
    })),
    path('<str:pk>/', UsersViewSet.as_view({
        'delete': 'destroy',

        'patch': 'partial_update',
    }))
]