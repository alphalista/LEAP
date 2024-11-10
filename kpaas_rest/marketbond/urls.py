from rest_framework.routers import DefaultRouter
from django.urls import path, include

from .models import ET_Bond_Holding
from .views import (
    MarketBondIssueInfoViewSet,
    MarketBondSearchInfoViewSet,
    MarketBondInquireAskingPriceViewSet,
    MarketBondAvgUnitViewSet,
    MarketBondInquireDailyItemChartPriceViewSet,
    MarketBondInquirePriceViewSet,
    MarketBondInquireCCNLViewSet,
    MarketBondInquireDailyPriceViewSet,
    MarketBondViewSet,
    ClickCountViewSet,
    MarketBondCmbViewSet,
    ET_Bond_Interest_view,
)

router = DefaultRouter()
router.register('marketbond', MarketBondViewSet, basename='marketbond')
router.register('combined', MarketBondCmbViewSet, basename='combined')
router.register('issue-info', MarketBondIssueInfoViewSet, basename='marketbondissueinfo')
router.register('search-info', MarketBondSearchInfoViewSet, basename='marketbondsearchinfo')
router.register('inquire-asking-price', MarketBondInquireAskingPriceViewSet, basename='marketbondinquireaskingprice')
router.register('avg-unit', MarketBondAvgUnitViewSet, basename='marketbondavgunit')
router.register('inquire-daily-item-chart-price', MarketBondInquireDailyItemChartPriceViewSet, basename='marketbondinquiredailyitemchartprice')
router.register('inquire-price', MarketBondInquirePriceViewSet, basename='marketbondinquireprice')
router.register('inquire-ccnl', MarketBondInquireCCNLViewSet, basename='marketbondinquireccnl')
router.register('inquire-daily-price', MarketBondInquireDailyPriceViewSet, basename='marketbondinquiredailyprice')
router.register('click-count', ClickCountViewSet, basename='marketbondclickcount')



urlpatterns = [
    path('', include(router.urls)),
    path('interest/<str:user_id>/', ET_Bond_Interest_view.as_view({
        'get': 'list',
        'post': 'create',
        'put': 'update',
        'delete': 'destroy'
    }), name='interest'),
    path('interest/<str:user_id>/<str:bond_code>/', ET_Bond_Interest_view.as_view({
        'delete': 'destroy'
    }), name='interest_delete'),
    # path('holding/<str:user_id>/', ET_Bond_Holding_view.as_view({
    #     'get': 'list',
    #     'post': 'create',
    #     'put': 'update',
    #     'delete': 'destroy'
    # })),
    # path('holding/<str:user_id>/<str:bond_code>/', ET_Bond_Holding_view.as_view({
    #     'delete': 'destroy'
    # }))
]