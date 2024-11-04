from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import filters
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import OuterRef, Subquery, CharField
from typing import Any

from rest_framework import generics


from .models import (
    MarketBondCode,
    MarketBondIssueInfo,
    MarketBondSearchInfo,
    MarketBondInquireAskingPrice,
    MarketBondAvgUnit,
    MarketBondInquireDailyItemChartPrice,
    MarketBondInquirePrice,
    MarketBondInquireCCNL,
    MarketBondInquireDailyPrice,
    MarketBondCmb,
    ClickCount,
)

from .serializer import (
    MarketBondSerializer,
    MarketBondCodeSerializer,
    MarketBondIssueInfoSerializer,
    MarketBondSearchInfoSerializer,
    MarketBondInquireAskingPriceSerializer,
    MarketBondAvgUnitSerializer,
    MarketBondInquireDailyItemChartPriceSerializer,
    MarketBondInquirePriceSerializer,
    MarketBondInquireCCNLSerializer,
    MarketBondInquireDailyPriceSerializer,
    MarketBondCmbSerializer,
    ClickCountSerializer,
)


from rest_framework import viewsets, status


# Create your views here.

class MarketBondCmbViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondCmb.objects.all()
    serializer_class = MarketBondCmbSerializer


class MarketBondViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondIssueInfo.objects.none()  # 임의의 빈 쿼리셋
    serializer_class = MarketBondSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['pdno', 'prdt_name', 'nice_crdt_grad_text']  # 정확한 값 매칭
    search_fields = ['pdno', 'prdt_name']  # 부분 문자열 검색
    ordering_fields = ['pdno', 'prdt_name', 'srfc_inrt', 'bond_prpr', 'bidp_rsqn1']  # 정렬 가능한 필드
# 기본 필터
# /api/users/?username=john
# 검색
# /api/users/?search=john
# 정렬
# /api/users/?ordering=-created_at
# 복합 필터
# /api/users/?username=john&ordering=-created_at&search=doe

    @action(detail=False, methods=['GET'])
    def data(self, request, *args, **kwargs):
        pdno = self.request.query_params.get('pdno', None)
        code = MarketBondCode.objects.filter(code=pdno).first()
        if pdno is not None:
            issue_info_query = MarketBondIssueInfo.objects.filter(code=code).first()
            inquire_price_query = MarketBondInquirePrice.objects.filter(code=code).first()
            inquire_asking_price_query = MarketBondInquireAskingPrice.objects.filter(code=code).order_by('-id').first()

            issue_info_data = MarketBondIssueInfoSerializer(issue_info_query).data if issue_info_query else None
            inquire_price_data = MarketBondInquirePriceSerializer(inquire_price_query).data if inquire_price_query else None
            inquire_asking_price_data = MarketBondInquireAskingPriceSerializer(inquire_asking_price_query).data if inquire_asking_price_query else None

            # Create the response data dictionary
            data = {
                'issue_info_data': issue_info_data,
                'inquire_price_data': inquire_price_data,
                'inquire_asking_price_data': inquire_asking_price_data,
            }

            # Return the response
            return Response(data, status=status.HTTP_200_OK)

        return Response({'error': 'No data found'}, status=status.HTTP_404_NOT_FOUND)


class MarketBondCodeViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondCode.objects.all()
    serializer_class = MarketBondCodeSerializer


class MarketBondIssueInfoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondIssueInfo.objects.all()
    serializer_class = MarketBondIssueInfoSerializer


class MarketBondSearchInfoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondSearchInfo.objects.all()
    serializer_class = MarketBondSearchInfoSerializer


class MarketBondInquireAskingPriceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondInquireAskingPrice.objects.all()
    serializer_class = MarketBondInquireAskingPriceSerializer


class MarketBondAvgUnitViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondAvgUnit.objects.all()
    serializer_class = MarketBondAvgUnitSerializer


class MarketBondInquireDailyItemChartPriceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondInquireDailyItemChartPrice.objects.all()
    serializer_class = MarketBondInquireDailyItemChartPriceSerializer


class MarketBondInquirePriceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondInquirePrice.objects.all()
    serializer_class = MarketBondInquirePriceSerializer


class MarketBondInquireCCNLViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondInquireCCNL.objects.all()
    serializer_class = MarketBondInquireCCNLSerializer


class MarketBondInquireDailyPriceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondInquireDailyPrice.objects.all()
    serializer_class = MarketBondInquireDailyPriceSerializer


class ClickCountViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = ClickCount.objects.all()
    serializer_class = ClickCountSerializer
    @action(detail=False, methods=['post'])
    def record_click(self, request, *args, **kwargs):
        code = request.data['code']
        if not code:
            return Response({'error': 'code is empty'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            code = MarketBondCode.objects.filter(code=code).first()
            if code:
                click_count, created = ClickCount.objects.get_or_create(code=code)
                click_count.increment()
                click_count.save()
                serializer = self.get_serializer(click_count)
                return Response(serializer.data)
            else:
                return Response({'error': 'marketbond does not exist'}, status=status.HTTP_400_BAD_REQUEST)
