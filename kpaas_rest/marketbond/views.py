from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import filters
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import OuterRef, Subquery, CharField
from typing import Any
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import filters
from rest_framework import generics

import copy


import datetime

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
    ClickCount, ET_Bond_Interest, Users,
    ET_Bond_Holding, MarketBondPreDataDays, MarketBondPreDataWeeks, MarketBondPreDataMonths
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
    ClickCountSerializer, ET_Bond_Interest_Serializer,
    ET_Bond_Holding_Serializer,
    Market_Bond_Days_Serializer,
    Market_Bond_Weeks_Serializer,
    Market_Bond_Months_Serializer
)


from rest_framework import viewsets, status


# Create your views here.

class MarketBondCmbViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondCmb.objects.all()
    serializer_class = MarketBondCmbSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['issue_info_data__pdno', 'issue_info_data__prdt_name', 'issue_info_data__nice_crdt_grad_text']  # 정확한 값 매칭
    search_fields = ['issue_info_data__pdno', 'issue_info_data__prdt_name']  # 부분 문자열 검색
    ordering_fields = ['issue_info_data__pdno', 'issue_info_data__prdt_name', 'issue_info_data__srfc_inrt', 'inquire_price_data__bond_prpr', 'inquire_asking_price_data__bidp_rsqn1']  # 정렬 가능한 필드


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

            if issue_info_data and inquire_price_data and inquire_asking_price_data:
                data['duration'] = {"duration": str(self.MacDuration(
                    issue_info_data.get('bond_int_dfrm_mthd_cd'),
                    float(issue_info_data.get('srfc_inrt')),
                    10000,
                    float(inquire_price_data.get('ernn_rate')),
                    issue_info_data.get('expd_dt'),
                    int(issue_info_data.get('int_dfrm_mcnt')),
                ))}

            # Return the response
            return Response(data, status=status.HTTP_200_OK)

        return Response({'error': 'No data found'}, status=status.HTTP_404_NOT_FOUND)

    # 인자 매핑
    # int_type: MarketBondIssueInfo 모델의 bond_int_dfrm_mthd_cd
    # interest_percentage: MarketBondIssueInfo 모델의 srfc_inrt
    # face_value: 10,000으로고정 상세페이지에서는 (계산기에서 해당 인수가 필요하므로 인수로 놔둠)
    # YTM: MarketBondInquirePrice 모델의 ernn_rate
    # mat_date: MarketBondIssueInfo 모델의 expd_dt
    # interest_cycle_period: MarketBondIssueInfo 모델의 int_dfrm_mcnt
    def MacDuration(self, int_type, interest_percentage, face_value, YTM, mat_date, interest_cycle_period):
        """
        :param int_type: 자료형: str, 이자 지급 형태를 말하며, '이표채', '복리채', '할인채' 등등이 들어갑니다.
        :param interest_percentage: 자료형: double, 이자율을 말합니다.
        :param face_value: 자료형: int, 액면가를 말하며, 수량(단위: 천원)일때 수량 * 1000을 한 값입니다.
        :param YTM: 자료형: double, (세전) 수익률을 말합니다.
        :param mat_date: 자료형: str(YYYYmmdd)형식. 예) "20240103", 만기일을 말합니다.
        :param interest_cycle_period: 자료형: int, 이자 지급주기를 말합니다.
        :return: 자료형: double
        """
        # 남은 이자 지급 횟수 계산 (만기일까지)
        today = datetime.datetime.today()
        maturity_date = datetime.datetime(int(mat_date[:4]), int(mat_date[4:6]), int(mat_date[6:]))
        months_to_maturity = (maturity_date.year - today.year) * 12 + (maturity_date.month - today.month)
        remain_count = int(months_to_maturity / interest_cycle_period)

        if ('이표' in int_type or '3' in int_type) and remain_count != 0:
            # 할인율을 분기별로 계산
            cnt_per_year = 12 / interest_cycle_period
            one_plus_YTM = 1 + (YTM / 100 / cnt_per_year)

            # 쿠폰 이자 계산 (분기마다 지급)
            coupon = (interest_percentage / 100) * face_value / cnt_per_year

            now_value = 0  # 현재 가치의 총합
            weight_value = 0  # 가중된 현재 가치의 총합

            # 각 이자 지급 시점에 대한 듀레이션 계산
            for i in range(1, remain_count + 1):
                # 마지막 현금 흐름에는 원금을 포함
                cash_flow = coupon if i < remain_count else (coupon + face_value)

                # 분기별 할인율 적용하여 현재 가치 계산
                coupon_div_ytm = cash_flow / pow(one_plus_YTM, i)

                # 가중치를 연 단위로 조정하여 반영
                weight = i / cnt_per_year
                now_value += coupon_div_ytm
                weight_value += coupon_div_ytm * weight

            # 듀레이션 계산
            mac_duration = weight_value / now_value if now_value != 0 else 0
            return round(mac_duration, 2)
        else:
            # 만기일 까지를 듀레이션으로 보장
            specific_date = datetime.datetime(int(mat_date[:4]), int(mat_date[4:6]), int(mat_date[6:]))
            today = datetime.datetime.today()
            difference = (specific_date - today).days / 365.25
            return round(difference, 2)


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


class ET_Bond_Interest_view(viewsets.ModelViewSet):
    # GET 요청은 성공
    # POST 요청 성공
    # DELETE 요청 성공
    serializer_class = ET_Bond_Interest_Serializer
    def get_queryset(self):
        # GET 요청일 때 user_id를 인수로 받습니다.
        user_id = self.kwargs.get('user_id')
        target = ET_Bond_Interest.objects.filter(user_id=user_id)
        # target의 ET_Bond의 값은 ET_Bond의 id 값이 노출됨
        # 시리얼라이저의 to_representation()로 해결
        return target

    def create(self, request, *args, **kwargs):
        data = request.data.copy()
        try:
            bond_instance = MarketBondCode.objects.get(code=data['bond_code'])
            data['bond_code'] = int(bond_instance.id)
        except MarketBondCode.DoesNotExist:
            return Response({"bond_code": "해당 bond_code가 존재하지 않습니다."}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    # delete 요청시 pk를 이용해 객체를 가져옴
    def destroy(self, request, *args, **kwargs):
        try:
            bond_instance = MarketBondCode.objects.get(code=self.kwargs.get('bond_code'))
            instance = self.get_queryset().filter(user_id=self.kwargs.get('user_id')).filter(bond_code=bond_instance.id)
            if instance:
                self.perform_destroy(instance)
                return Response(status=status.HTTP_204_NO_CONTENT)
            else: return Response(status=status.HTTP_404_NOT_FOUND)
        except MarketBondCode.DoesNotExist:
            return Response({"ERROR": "요청하신 채권 코드가 존재하지 않습니다."}, status=status.HTTP_400_BAD_REQUEST)
        except Users.DoesNotExist:
            return Response({"ERROR": "요청하신 유저가 존재하지 않습니다."}, status=status.HTTP_400_BAD_REQUEST)



class ET_Bond_Holding_view(viewsets.ModelViewSet):
    serializer_class = ET_Bond_Holding_Serializer
    # GET은 성공
    def get_queryset(self):
        # GET 요청일 때 user_id를 인수로 받습니다.
        user_id = self.kwargs.get('user_id')
        target = ET_Bond_Holding.objects.filter(user_id=user_id)
        # target의 ET_Bond의 값은 ET_Bond의 id 값이 노출됨
        # 시리얼라이저의 to_representation()로 해결
        return target

    def create(self, request, *args, **kwargs):
        data = request.data.copy()
        try:
            bond_instance = MarketBondCode.objects.get(code=data['bond_code'])
            data['bond_code'] = int(bond_instance.id)
        except MarketBondCode.DoesNotExist:
            return Response({"bond_code": "해당 bond_code가 존재하지 않습니다."}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class EtBondPreDataDaysView(viewsets.ReadOnlyModelViewSet):
    serializer_class = Market_Bond_Days_Serializer
    def get_queryset(self):
        real_bond_code = self.kwargs.get('bond_code')
        ins_id = None
        try:
            ins_id = MarketBondCode.objects.get(code=real_bond_code).id
        except MarketBondCode.DoesNotExist:
            return Response({"Error": "유효한 채권 코드가 아닙니다."} ,status=status.HTTP_404_NOT_FOUND)

        day_instances = MarketBondPreDataDays.objects.filter(bond_code=ins_id).order_by('add_date')
        return day_instances

class EtBondPreDataWeeksView(viewsets.ReadOnlyModelViewSet):
    serializer_class = Market_Bond_Weeks_Serializer
    def get_queryset(self):
        real_bond_code = self.kwargs.get('bond_code')
        ins_id = None
        try:
            ins_id = MarketBondCode.objects.get(code=real_bond_code).id
        except MarketBondCode.DoesNotExist:
            return Response({"Error": "유효한 채권 코드가 아닙니다."} ,status=status.HTTP_404_NOT_FOUND)

        day_instances = MarketBondPreDataWeeks.objects.filter(bond_code=ins_id).order_by('add_date')
        return day_instances

class EtBondPreDataMonthsView(viewsets.ReadOnlyModelViewSet):
    serializer_class = Market_Bond_Months_Serializer
    def get_queryset(self):
        real_bond_code = self.kwargs.get('bond_code')
        ins_id = None
        try:
            ins_id = MarketBondCode.objects.get(code=real_bond_code).id
        except MarketBondCode.DoesNotExist:
            return Response({"Error": "유효한 채권 코드가 아닙니다."} ,status=status.HTTP_404_NOT_FOUND)

        day_instances = MarketBondPreDataMonths.objects.filter(bond_code=ins_id).order_by('add_date')
        return day_instances
