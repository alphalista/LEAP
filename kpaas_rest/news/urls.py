from rest_framework.routers import DefaultRouter

from .views import (
    NaverNewsViewSet,
    SearchKeywordViewSet
)

router = DefaultRouter()
router.register("data", NaverNewsViewSet)
router.register("keyword", SearchKeywordViewSet)


urlpatterns = router.urls
