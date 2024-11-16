from rest_framework.routers import DefaultRouter

from .views import (
    NaverNewsViewSet,
    SearchKeywordViewSet,
    UserNewsViewSet
)
from django.urls import path, include

router = DefaultRouter()
router.register("data", NaverNewsViewSet)
router.register("keyword", SearchKeywordViewSet)


urlpatterns = [
    path('', include(router.urls)),
    path('searchKeyword/<str:user_id>/', UserNewsViewSet.as_view({
        'get': 'list',
        'post': 'create',
        'delete': 'destroy'
    })),
    path('searchKeyword/<str:user_id>/<int:pk>/', UserNewsViewSet.as_view({
        'delete': 'destroy'
    }))
]
