from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import filters
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import OuterRef, Subquery
from typing import Any


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
    ClickCountSerializer,
)


from rest_framework import viewsets, status


# Create your views here.

class MarketBondViewSet(viewsets.ReadOnlyModelViewSet):
    # queryset = MarketBondIssueInfo.objects.none()  # 임의의 빈 쿼리셋
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

    class MarketBondViewSet(viewsets.ReadOnlyModelViewSet):
        serializer_class = MarketBondSerializer
        filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
        filterset_fields = ['pdno', 'prdt_name', 'nice_crdt_grad_text']
        search_fields = ['pdno', 'prdt_name']
        ordering_fields = ['pdno', 'prdt_name', 'srfc_inrt', 'bond_prpr', 'bidp_rsqn1']

        def get_queryset(self):
            # 각 채권 코드별 최신 호가 데이터를 위한 서브쿼리
            latest_asking_price = MarketBondInquireAskingPrice.objects.filter(
                code=OuterRef('code')
            ).order_by('-id').values(
                'code', 'aspr_acpt_hour', 'bond_askp1', 'bond_askp2', 'bond_askp3', 'bond_askp4', 'bond_askp5',
                'bond_bidp1', 'bond_bidp2', 'bond_bidp3', 'bond_bidp4', 'bond_bidp5',
                'askp_rsqn1', 'askp_rsqn2', 'askp_rsqn3', 'askp_rsqn4', 'askp_rsqn5',
                'bidp_rsqn1', 'bidp_rsqn2', 'bidp_rsqn3', 'bidp_rsqn4', 'bidp_rsqn5',
                'total_askp_rsqn', 'total_bidp_rsqn', 'ntby_aspr_rsqn',
                'seln_ernn_rate1', 'seln_ernn_rate2', 'seln_ernn_rate3', 'seln_ernn_rate4', 'seln_ernn_rate5',
                'shnu_ernn_rate1', 'shnu_ernn_rate2', 'shnu_ernn_rate3', 'shnu_ernn_rate4', 'shnu_ernn_rate5'
            )[:1]

            # 각 채권 코드별 최신 가격 데이터를 위한 서브쿼리
            latest_price = MarketBondInquirePrice.objects.filter(
                code=OuterRef('code')
            ).order_by('-id').values(
                'code', 'stnd_iscd', 'hts_kor_isnm', 'bond_prpr', 'prdy_vrss_sign', 'bond_prdy_vrss',
                'prdy_ctrt', 'acml_vol', 'bond_prdy_clpr', 'bond_oprc', 'bond_hgpr', 'bond_lwpr', 'ernn_rate',
                'oprc_ert', 'hgpr_ert', 'lwpr_ert', 'bond_mxpr', 'bond_llam'
            )[:1]

            # 기본 정보에 가격 정보와 호가 정보를 조인
            queryset = MarketBondIssueInfo.objects.select_related('code').annotate(
                price_info=Subquery(latest_price),
                asking_info=Subquery(latest_asking_price)
            )

            return queryset

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
