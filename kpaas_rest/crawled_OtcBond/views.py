from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from django.utils import timezone
import os, sys

from .models import OTC_Bond, OtcBondPreDataWeeks, OTC_Bond_Interest, OTC_Bond_Holding, OTC_Bond_Expired, OtcBondPreDataDays, OtcBondPreDataMonths
from .serializers import OTC_Bond_Serializer, OTC_Bond_Interest_Serializer, OTC_Bond_Holding_Serializer, OTC_Bond_Expired_Serializer, OTC_Bond_Days_Serializer, OTC_Bond_Weeks_Serializer, OTC_Bond_Months_Serializer


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

class OTC_Bond_Holding_view(viewsets.ModelViewSet):
    serializer_class = OTC_Bond_Holding_Serializer

    def get_queryset(self):
        user_id = self.kwargs.get('user_id')
        if user_id is not None:
            return OTC_Bond_Holding.objects.filter(user_id=user_id)
        return OTC_Bond_Holding.objects.all()

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