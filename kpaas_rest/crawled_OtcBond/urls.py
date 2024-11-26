from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import *

router = DefaultRouter()
router.register("otc-bond-all", OTC_Bond_All)
# router.register("interest", OTC_Bond_Interest_view)
urlpatterns = [
    path('', include(router.urls)),
    path('holding/<str:user_id>/', OTC_Bond_Holding_view.as_view({
            'get': 'list',          # 전체 목록 조회
            'post': 'create',       # 새 인스턴스 생성
            'put': 'update',        # 전체 업데이트
            'patch': 'partial_update',  # 부분 업데이트
        }
    )),
    path('holding/<str:user_id>/<int:ins_id>/', OTC_Bond_Holding_view.as_view({
            'delete': 'destroy'     # 삭제
    })),
    path('interest/<str:user_id>/', OTC_Bond_Interest_view.as_view({
            'get': 'list',          # 전체 목록 조회
            'post': 'create',       # 새 인스턴스 생성
            'put': 'update',        # 전체 업데이트
            'patch': 'partial_update',  # 부분 업데이트
            'delete': 'destroy'     # 삭제
    })),
    path('expired/<str:user_id>/', OTC_Bond_Expired_view.as_view({
        'get': 'list'
    })),
    path('days/<str:bond_code>/', OTC_Bond_Days_View.as_view({
        'get': 'list'
    })),
    path('weeks/<str:bond_code>/', OTC_Bond_Weeks_View.as_view({
        'get': 'list'
    })),
    path('months/<str:bond_code>/', OTC_Bond_Months_View.as_view({
        'get': 'list'
    })),
    path('filter/', OtcBondFilterView.as_view({
        'get': 'list'
    })),
    path('trending/', OtcBondTrendingView.as_view({
        'get': 'list'
    }))
]
