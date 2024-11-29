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
    ET_Bond_Holding_view,
    EtBondPreDataDaysView,
    EtBondPreDataWeeksView,
    EtBondPreDataMonthsView
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
    path('interest/', ET_Bond_Interest_view.as_view({
        'get': 'list',
        'post': 'create',
        'put': 'update',
        'delete': 'destroy'
    }), name='interest'),
    path('interest/<str:bond_code>/', ET_Bond_Interest_view.as_view({
        'delete': 'destroy'
    }), name='interest_delete'),
    path('holding/', ET_Bond_Holding_view.as_view({
        'get': 'list',
        'post': 'create',
        'put': 'update',
    })),
    path('holding/<int:pk>/', ET_Bond_Holding_view.as_view({
        'delete': 'destroy'
    })),
    path('days/<str:bond_code>/', EtBondPreDataDaysView.as_view({
        'get': 'list',
    })),
    path('weeks/<str:bond_code>/', EtBondPreDataWeeksView.as_view({
        'get': 'list',
    })),
    path('months/<str:bond_code>/', EtBondPreDataMonthsView.as_view({
        'get': 'list',
    })),
]