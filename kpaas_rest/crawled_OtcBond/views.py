from calendar import month

from dateutil.relativedelta import relativedelta
from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets, status
from django.utils import timezone
import os, sys

from rest_framework.response import Response

from .models import OTC_Bond, OtcBondPreDataWeeks, OTC_Bond_Interest, OTC_Bond_Holding, OTC_Bond_Expired, \
    OtcBondPreDataDays, OtcBondPreDataMonths, HowManyInterest, OtcBondTrending
from .serializers import OTC_Bond_Serializer, OTC_Bond_Interest_Serializer, OTC_Bond_Holding_Serializer, \
    OTC_Bond_Expired_Serializer, OTC_Bond_Days_Serializer, OTC_Bond_Weeks_Serializer, OTC_Bond_Months_Serializer, \
    OTC_Bond_Trending_Serializer


from django.db.models import IntegerField, DateField, Value, FloatField
from django.db.models.functions import Cast, Substr, Concat, Replace

from datetime import timedelta, datetime


class OTC_Bond_All(viewsets.ReadOnlyModelViewSet):
    queryset = OTC_Bond.objects.filter(add_date=timezone.now())
    # queryset = OTC_Bond.objects.all()
    serializer_class = OTC_Bond_Serializer

    def get_queryset(self):
        query = self.request.query_params.get('query')
        if query:
            bond_code_search = self.queryset.filter(code__icontains=query)
            prdt_name_search = self.queryset.filter(prdt_name__icontains=query)
            join = bond_code_search | prdt_name_search
            return join.distinct()
        return self.queryset

class OTC_Bond_Interest_view(viewsets.ModelViewSet):
    serializer_class = OTC_Bond_Interest_Serializer

    def get_queryset(self):
        user_id = self.kwargs.get('user_id')
        if user_id is not None:
            return OTC_Bond_Interest.objects.filter(user_id=user_id)
        return OTC_Bond_Interest.objects.all()

    def create(self, request, *args, **kwargs):
        try:
            ins = HowManyInterest.objects.get(bond_code=request.data.get('bond_code'))
            HowManyInterest.objects.update_or_create(
                bond_code=OTC_Bond.objects.get(code=request.data.get('bond_code')),
                defaults={
                    'interest': ins.interest + 1
                }
            )
        except HowManyInterest.DoesNotExist:
            HowManyInterest.objects.create(bond_code=OTC_Bond.objects.get(code=request.data.get('bond_code')), interest=1)
        serializer = OTC_Bond_Interest_Serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class OTC_Bond_Holding_view(viewsets.ModelViewSet):
    serializer_class = OTC_Bond_Holding_Serializer

    def get_queryset(self):
        user_id = self.kwargs.get('user_id')
        if user_id is not None:
            return OTC_Bond_Holding.objects.filter(user_id=user_id)
        return OTC_Bond_Holding.objects.all()

    def destroy(self, request, *args, **kwargs):
        id = self.kwargs.get('ins_id')
        try:
            ins = OTC_Bond_Holding.objects.get(pk=id)
            ins.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except OTC_Bond_Holding.DoesNotExist:
            return Response('OTC_Bond_Holding does not exist', status=404)

class OTC_Bond_Expired_view(viewsets.ReadOnlyModelViewSet):
    serializer_class = OTC_Bond_Expired_Serializer

    def get_queryset(self):
        user_id = self.kwargs.get('user_id')
        if user_id is not None:
            return OTC_Bond_Expired.objects.filter(user_id=user_id)
        return OTC_Bond_Expired.objects.all()

class OTC_Bond_Days_View(viewsets.ReadOnlyModelViewSet):
    serializer_class = OTC_Bond_Days_Serializer

    def get_queryset(self):
        bond_code = self.kwargs.get('bond_code')
        if bond_code is not None:
            return OtcBondPreDataDays.objects.filter(bond_code=bond_code)
        return OtcBondPreDataDays.objects.all()

class OTC_Bond_Months_View(viewsets.ReadOnlyModelViewSet):
    serializer_class = OTC_Bond_Months_Serializer
    def get_queryset(self):
        bond_code = self.kwargs.get('bond_code')
        if bond_code is not None:
            return OtcBondPreDataMonths.objects.filter(bond_code=bond_code)
        return OtcBondPreDataMonths.objects.all()

class OTC_Bond_Weeks_View(viewsets.ReadOnlyModelViewSet):
    serializer_class = OTC_Bond_Weeks_Serializer
    def get_queryset(self):
        bond_code = self.kwargs.get('bond_code')
        if bond_code is not None:
            return OtcBondPreDataWeeks.objects.filter(bond_code=bond_code)
        return OtcBondPreDataWeeks.objects.all()


# 장외 채권의 필터 방법
# 파라미터로 주어집니다.
# 파라미터의 순서는 만기일
# 채권 위험도
# 수익률
# 이자율
class OtcBondFilterView(viewsets.ReadOnlyModelViewSet):
    serializer_class = OTC_Bond_Serializer

    def get_queryset(self):
        # 수익률(완)
        if self.request.query_params.get('YTM'): # 수익률
            data = self.request.query_params.get('YTM')
            query = OTC_Bond.objects.filter(add_date=timezone.now())
            query = query.annotate(
                YTM_int=Cast('YTM', FloatField()),
            )
            if data == 'asc': return query.order_by('YTM_int')
            elif data == 'desc': return query.order_by('-YTM_int')
        elif self.request.query_params.get('expd'): # 만기일
            data = self.request.query_params.get('expd')
            query = OTC_Bond.objects.annotate(
                date_field=Cast(
                    Concat(
                        Substr('expd_dt', 1, 4), Value('-'),
                        Substr('expd_dt', 5, 2), Value('-'),
                        Substr('expd_dt', 7, 2)
                    )
                    , DateField())
            ).filter(add_date=timezone.now())
            if data == 'asc':
                return query.order_by('date_field')
            elif data == 'desc':
                return query.order_by('-date_field')
            else:
                try:
                    data = int(data)
                    if data == '6': future = timezone.now() + relativedelta(months=6) # 6개월 이내 만기일을 일컫습니다.
                    else : future = timezone.now() + timedelta(days=365*data)
                    return query.filter(date_field__lte=future).order_by('-date_field')
                except ValueError:
                    return OTC_Bond.objects.all()
        elif self.request.query_params.get('int_percent'): # 이자율 완
            data = self.request.query_params.get('int_percent')
            query = OTC_Bond.objects.filter(add_date=timezone.now())
            if data == 'asc': return query.order_by('interest_percentage')
            elif data == 'desc': return query.order_by('-interest_percentage')
        elif self.request.query_params.get('danger'): # 위험도 완.
            data = self.request.query_params.get('danger')
            query = OTC_Bond.objects.filter(add_date=timezone.now()).annotate(
                strip_danger=Replace('nice_crdt_grad_text', Value(' '), Value(''))
            ).filter(strip_danger=data)
            return query

        return OTC_Bond.objects.all()


class OtcBondTrendingView(viewsets.ReadOnlyModelViewSet):
    queryset = OtcBondTrending.objects.all().order_by('-YTM')
    serializer_class = OTC_Bond_Trending_Serializer