from django_filters.rest_framework import DjangoFilterBackend, FilterSet, BooleanFilter

from django.utils.timezone import now
from datetime import datetime, timedelta

from marketbond.models import MarketBondCmb


class MarketBondCmbFilter(FilterSet):
    maturity_5_years = BooleanFilter(
        method='filter_by_maturity',
        label='만기 5년 이내',
    ),
    maturity_3_years = BooleanFilter(
        method='filter_by_maturity',
        label='만기 3년 이내',
    ),
    maturity_1_years = BooleanFilter(
        method='filter_by_maturity',
        label='만기 1년 이내',
    ),
    maturity_6_months = BooleanFilter(
        method='filter_by_maturity',
        label='만기 6개월 이내',
    )

    def filter_by_maturity(self, queryset, name, value):
        if not value:
            return queryset

        today = now().date()
        if name == 'maturity_5_years':
            end_date = today + timedelta(days=5 * 365)
        elif name == 'maturity_3_years':
            end_date = today + timedelta(days=3 * 365)
        elif name == 'maturity_1_year':
            end_date = today + timedelta(days=365)
        elif name == 'maturity_6_months':
            end_date = today + timedelta(days=180)
        else:
            return queryset

        return queryset.filter(
            issue_info_data__expt_dt__lte=end_date.strftime('%Y%m%d')
        )

    class Meta:
        model = MarketBondCmb
        fields = []
