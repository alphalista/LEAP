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

from crawled_OtcBond.models import HowManyInterest
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
    ET_Bond_Holding, MarketBondPreDataDays, MarketBondPreDataWeeks, MarketBondPreDataMonths,
    MarketBondHowManyInterest,
    MarketBondTrending,
    ET_Bond_Expired
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
    Market_Bond_Months_Serializer, MarketBondTrendingSerializer,
    MarketBondExpiredSerializer
)

from .filters import MarketBondCmbFilter

from rest_framework import viewsets, status

from django.db.models import IntegerField, DateField, Value, FloatField
from django.db.models.functions import Cast, Substr, Concat, Replace
from dateutil.relativedelta import relativedelta
from datetime import timedelta
from django.utils import timezone
from django.db.models.functions import Cast
from django.db.models import FloatField


# Create your views here.

class MarketBondCmbViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondCmb.objects.all()
    serializer_class = MarketBondCmbSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = MarketBondCmbFilter
    filterset_fields = ['issue_info_data__pdno', 'issue_info_data__prdt_name', 'issue_info_data__nice_crdt_grad_text']  # 정확한 값 매칭
    search_fields = ['issue_info_data__pdno', 'issue_info_data__prdt_name']  # 부분 문자열 검색
    ordering_fields = ['issue_info_data__pdno', 'issue_info_data__prdt_name', 'issue_info_data__srfc_inrt', 'inquire_price_data__bond_prpr', 'inquire_asking_price_data__seln_ernn_rate1', 'issue_info_data__expd_dt', 'inquire_asking_price_data__total_askp_rsqn', 'total_askp_rsqn_float', 'seln_ernn_rate1_float', 'srfc_inrt_float', 'expd_dt_date']  # 정렬 가능한 필드

    def get_queryset(self):
        # Exclude records where relevant fields are 0
        querySet = super().get_queryset().exclude(
            issue_info_data__srfc_inrt=0
        ).exclude(
            inquire_price_data__bond_prpr=0
        ).exclude(
            inquire_asking_price_data__bidp_rsqn1=0
        )
        querySet = querySet.annotate(
            total_askp_rsqn_float=Cast('inquire_asking_price_data__total_askp_rsqn', FloatField())
        ).annotate(
            seln_ernn_rate1_float=Cast('inquire_asking_price_data__seln_ernn_rate1', FloatField())
        ).annotate(
            srfc_inrt_float=Cast('issue_info_data__srfc_inrt', FloatField())
        ).annotate(
            expd_dt_date=Cast('issue_info_data__expd_dt', FloatField())
        )
        if self.request.query_params.get('expd_dt'):
            data = self.request.query_params.get('expd_dt')
            query = querySet.annotate(
                date_field=Cast(
                    Concat(
                        Substr('issue_info_data__expd_dt', 1, 4), Value('-'),
                        Substr('issue_info_data__expd_dt', 5, 2), Value('-'),
                        Substr('issue_info_data__expd_dt', 7, 2)
                    )
                    , DateField())
            )
            if data == 'asc':
                return query
            elif data == 'desc':
                return query
            else:
                try:
                    data = int(data)
                    if data == 6: future = timezone.now() + relativedelta(months=6) # 6개월 이내 만기일을 일컫습니다.
                    else : future = timezone.now() + timedelta(days=365*data)
                    return query.filter(date_field__lte=future).order_by('-date_field')
                except ValueError:
                    return querySet
        elif self.request.query_params.get('grad'):
            data = self.request.query_params.get('grad')
            # obj = MarketBondIssueInfo.objects
            query = querySet
            if data == 'AAA':
                query = querySet.filter(issue_info_data__kbp_crdt_grad_text='AAA')
            elif data == 'AA':
                plus = querySet.filter(issue_info_data__kbp_crdt_grad_text='AA+')
                zero = querySet.filter(issue_info_data__kbp_crdt_grad_text='AA')
                minus = querySet.filter(issue_info_data__kbp_crdt_grad_text='AA-')
                query = plus | zero | minus
            elif data == 'A':
                plus = querySet.filter(issue_info_data__kbp_crdt_grad_text='A+')
                zero = querySet.filter(issue_info_data__kbp_crdt_grad_text='A')
                minus = querySet.filter(issue_info_data__kbp_crdt_grad_text='A-')
                query = plus | zero | minus
            elif data == 'BBB':
                plus = querySet.filter(issue_info_data__kbp_crdt_grad_text='BBB+')
                zero = querySet.filter(issue_info_data__kbp_crdt_grad_text='BBB')
                minus = querySet.filter(issue_info_data__kbp_crdt_grad_text='BBB-')
                query = plus | zero | minus
            elif data == 'BB':
                plus = querySet.filter(issue_info_data__kbp_crdt_grad_text='BB+')
                zero = querySet.filter(issue_info_data__kbp_crdt_grad_text='BB')
                minus = querySet.filter(issue_info_data__kbp_crdt_grad_text='BB-')
                query = plus | zero | minus
            elif data == 'B':
                plus = querySet.filter(issue_info_data__kbp_crdt_grad_text='B')
                zero = querySet.filter(issue_info_data__kbp_crdt_grad_text='B')
                minus = querySet.filter(issue_info_data__kbp_crdt_grad_text='B')
                query = plus | zero | minus
            elif data == 'CCC':
                plus = querySet.filter(issue_info_data__kbp_crdt_grad_text='CCC+')
                zero = querySet.filter(issue_info_data__kbp_crdt_grad_text='CCC')
                minus = querySet.filter(issue_info_data__kbp_crdt_grad_text='CCC-')
                under1 = querySet.filter(issue_info_data__kbp_crdt_grad_text='CC')
                under2 = querySet.filter(issue_info_data__kbp_crdt_grad_text='C')
                under3 = querySet.filter(issue_info_data__kbp_crdt_grad_text='D')
                query = plus | zero | minus | under1 | under2 | under3
            elif data == 'none':
                query = querySet.filter(issue_info_data__kbp_crdt_grad_text='')
            return query
        return querySet

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
                # TODO 듀레이션 키값 수정
                data['duration'] = {'duration':str(self.MacDuration(
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
    # queryset = MarketBondIssueInfo.objects.all()
    serializer_class = MarketBondIssueInfoSerializer

    def get_queryset(self):
        if self.request.query_params.get('expd_dt'):
            data = self.request.query_params.get('expd_dt')
            query = MarketBondIssueInfo.objects.annotate(
                date_field=Cast(
                    Concat(
                        Substr('expd_dt', 1, 4), Value('-'),
                        Substr('expd_dt', 5, 2), Value('-'),
                        Substr('expd_dt', 7, 2)
                    )
                    , DateField())
            )
            if data == 'asc':
                return query.order_by('date_field')
            elif data == 'desc':
                return query.order_by('-date_field')
            else:
                try:
                    data = int(data)
                    if data == 6: future = timezone.now() + relativedelta(months=6) # 6개월 이내 만기일을 일컫습니다.
                    else : future = timezone.now() + timedelta(days=365*data)
                    return query.filter(date_field__lte=future).order_by('-date_field')
                except ValueError:
                    return MarketBondIssueInfo.objects.all()
        elif self.request.query_params.get('grad'):
            data = self.request.query_params.get('grad')
            obj = MarketBondIssueInfo.objects
            query = MarketBondIssueInfo.objects.all()
            if data == 'AAA':
                query = obj.filter(kbp_crdt_grad_text='AAA')
            elif data == 'AA':
                plus = obj.filter(kbp_crdt_grad_text='AA+')
                zero = obj.filter(kbp_crdt_grad_text='AA')
                minus = obj.filter(kbp_crdt_grad_text='AA-')
                query = plus | zero | minus
            elif data == 'A':
                plus = obj.filter(kbp_crdt_grad_text='A+')
                zero = obj.filter(kbp_crdt_grad_text='A')
                minus = obj.filter(kbp_crdt_grad_text='A-')
                query = plus | zero | minus
            elif data == 'BBB':
                plus = obj.filter(kbp_crdt_grad_text='BBB+')
                zero = obj.filter(kbp_crdt_grad_text='BBB')
                minus = obj.filter(kbp_crdt_grad_text='BBB-')
                query = plus | zero | minus
            elif data == 'BB':
                plus = obj.filter(kbp_crdt_grad_text='BB+')
                zero = obj.filter(kbp_crdt_grad_text='BB')
                minus = obj.filter(kbp_crdt_grad_text='BB-')
                query = plus | zero | minus
            elif data == 'B':
                plus = obj.filter(kbp_crdt_grad_text='B')
                zero = obj.filter(kbp_crdt_grad_text='B')
                minus = obj.filter(kbp_crdt_grad_text='B')
                query = plus | zero | minus
            elif data == 'CCC':
                plus = obj.filter(kbp_crdt_grad_text='CCC+')
                zero = obj.filter(kbp_crdt_grad_text='CCC')
                minus = obj.filter(kbp_crdt_grad_text='CCC-')
                under1 = obj.filter(kbp_crdt_grad_text='CC')
                under2 = obj.filter(kbp_crdt_grad_text='C')
                under3 = obj.filter(kbp_crdt_grad_text='D')
                query = plus | zero | minus | under1 | under2 | under3
            elif data == 'none':
                query = obj.filter(kbp_crdt_grad_text='')
            return query
        return MarketBondIssueInfo.objects.all()


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
        user_id = self.request.user.user_id
        target = ET_Bond_Interest.objects.filter(user_id=user_id)
        # target의 ET_Bond의 값은 ET_Bond의 id 값이 노출됨
        # 시리얼라이저의 to_representation()로 해결
        query = self.request.query_params.get('query')
        if query:
            temp = []
            for each in target:
                temp.append(each.bond_code.id) # id 값이 드감
            code_search_result = MarketBondCode.objects.filter(id__in=temp).filter(code__icontains=query)
            name_search_result = MarketBondIssueInfo.objects.filter(code__in=temp).filter(prdt_name__icontains=query)
            temp.clear()
            for each in code_search_result:
                temp.append(each.id)
            for each in name_search_result:
                temp.append(each.code.id)
            return ET_Bond_Interest.objects.filter(bond_code__in=temp)
        return target

    def create(self, request, *args, **kwargs):
        data = request.data.copy()
        try:
            bond_instance = MarketBondCode.objects.get(code=data['bond_code'])
            data['bond_code'] = int(bond_instance.id)
            data['user_id'] = request.user.user_id
            ins = MarketBondHowManyInterest.objects.get(bond_code=bond_instance.id)
            MarketBondHowManyInterest.objects.update_or_create(
                bond_code=MarketBondCode.objects.get(code=data['bond_code']),
                defaults={
                    'interest': ins.interest + 1
                }
            )
        except MarketBondCode.DoesNotExist:
            return Response({"bond_code": "해당 bond_code가 존재하지 않습니다."}, status=status.HTTP_400_BAD_REQUEST)
        except MarketBondHowManyInterest.DoesNotExist:
            MarketBondHowManyInterest.objects.create(bond_code=MarketBondCode.objects.get(id=data['bond_code']), interest=1)
        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    # delete 요청시 pk를 이용해 객체를 가져옴
    def destroy(self, request, *args, **kwargs):
        try:
            bond_instance = MarketBondCode.objects.get(code=self.kwargs.get('bond_code'))
            instance = self.get_queryset().filter(user_id=self.request.user.user_id).filter(bond_code=bond_instance.id)
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
        user_id = self.request.user.user_id
        target = ET_Bond_Holding.objects.filter(user_id=user_id)
        # target의 ET_Bond의 값은 ET_Bond의 id 값이 노출됨
        # 시리얼라이저의 to_representation()로 해결
        query = self.request.query_params.get('query')
        if query:
            temp = []
            for each in target:
                temp.append(each.bond_code.id)  # id 값이 드감
            code_search_result = MarketBondCode.objects.filter(id__in=temp).filter(code__icontains=query)
            name_search_result = MarketBondIssueInfo.objects.filter(code__in=temp).filter(prdt_name__icontains=query)
            temp.clear()
            for each in code_search_result:
                temp.append(each.id)
            for each in name_search_result:
                temp.append(each.code.id)
            return ET_Bond_Holding.objects.filter(bond_code__in=temp)
        return target

    def create(self, request, *args, **kwargs):
        data = request.data.copy()
        try:
            bond_instance = MarketBondCode.objects.get(code=data['bond_code'])
            data['bond_code'] = int(bond_instance.id)
            data['user_id'] = request.user.user_id
        except MarketBondCode.DoesNotExist:
            return Response({"bond_code": "해당 bond_code가 존재하지 않습니다."}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def update(self, request, *args, **kwargs):
        try:
            data = request.data.copy()
            bond_instance = MarketBondCode.objects.get(code=data['bond_code'])
            data['bond_code'] = int(bond_instance.id)
            request_data = ET_Bond_Holding.objects.filter(user_id=request.user.user_id).get(bond_code=data['bond_code'])
        except MarketBondCode.DoesNotExist:
            return Response('MarketBondCod does not exist', status=404)
        except ET_Bond_Holding.DoesNotExist:
            return Response('ET_Bond_Holding does not exist', status=404)
        serializer = ET_Bond_Holding_Serializer(request_data, data=data, partial=True)
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

class MarketBondTrendingView(viewsets.ReadOnlyModelViewSet):
    queryset = MarketBondTrending.objects.all()
    serializer_class = MarketBondTrendingSerializer

class MarketBondExpiredView(viewsets.ReadOnlyModelViewSet):
    serializer_class = MarketBondExpiredSerializer
    def get_queryset(self):
        user_id = self.request.user.user_id
        target = ET_Bond_Expired.objects.filter(user_id=user_id)
        query = self.request.query_params.get('query')
        if query:
            temp = []
            for each in target:
                temp.append(each.bond_code.id)  # id 값이 드감
            code_search_result = MarketBondCode.objects.filter(id__in=temp).filter(code__icontains=query)
            name_search_result = MarketBondIssueInfo.objects.filter(code__in=temp).filter(prdt_name__icontains=query)
            temp.clear()
            for each in code_search_result:
                temp.append(each.id)
            for each in name_search_result:
                temp.append(each.code.id)
            return ET_Bond_Expired.objects.filter(bond_code__in=temp)
        return target
