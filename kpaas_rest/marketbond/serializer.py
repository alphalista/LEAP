from rest_framework import serializers

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
    ClickCount, ET_Bond_Interest, ET_Bond_Holding,
    MarketBondPreDataDays, MarketBondPreDataWeeks, MarketBondPreDataMonths
)


class MarketBondCodeSerializer(serializers.ModelSerializer):
    class Meta:
        model = MarketBondCode
        fields = "__all__"


class MarketBondIssueInfoSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondIssueInfo
        fields = "__all__"


class MarketBondSearchInfoSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondSearchInfo
        fields = "__all__"


class MarketBondInquireAskingPriceSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondInquireAskingPrice
        fields = "__all__"


class MarketBondAvgUnitSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondAvgUnit
        fields = "__all__"


class MarketBondInquireDailyItemChartPriceSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondInquireDailyItemChartPrice
        fields = "__all__"


class MarketBondInquirePriceSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondInquirePrice
        fields = "__all__"


class MarketBondInquireCCNLSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondInquireCCNL
        fields = "__all__"


class MarketBondInquireDailyPriceSerializer(serializers.ModelSerializer):
    code = serializers.PrimaryKeyRelatedField(queryset=MarketBondCode.objects.all())

    class Meta:
        model = MarketBondInquireDailyPrice
        fields = "__all__"

class MarketBondSerializer(serializers.Serializer):
    issue_info_data = MarketBondIssueInfoSerializer(read_only=True)
    inquire_price_data = MarketBondInquirePriceSerializer(read_only=True)
    inquire_asking_price_data = MarketBondInquireAskingPriceSerializer(read_only=True)


class MarketBondCmbSerializer(serializers.ModelSerializer):
    code = MarketBondCodeSerializer()
    issue_info_data = MarketBondIssueInfoSerializer()
    inquire_price_data = MarketBondInquirePriceSerializer()
    inquire_asking_price_data = MarketBondInquireAskingPriceSerializer()

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['duration'] = {"duration": str(self.MacDuration(
            data['issue_info_data']['bond_int_dfrm_mthd_cd'],
            float(data['issue_info_data']['bond_int_dfrm_mthd_cd']),
            10000,
            float(data['inquire_price_data']['ernn_rate']),
            data['issue_info_data']['expd_dt'],
            int(data['issue_info_data']['int_dfrm_mcnt'])
        ))}
        return data

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

    class Meta:
        model = MarketBondCmb
        fields = "__all__"


class ClickCountSerializer(serializers.ModelSerializer):
    market_bond_code = MarketBondCodeSerializer(read_only=True)
    class Meta:
        model = ClickCount
        fields = "__all__"


class ET_Bond_Interest_Serializer(serializers.ModelSerializer):
    def to_representation(self, instance):
        # ET_Bond의 id를 시리얼라이저를 통해 해결
        data = super().to_representation(instance)
        bond_info = instance.bond_code
        data.pop('bond_code')
        data['bond_code'] = bond_info.code
        return data

    # def validate_bond_code(self, value):
    #     try:
    #         market_bond = MarketBondCode.objects.get(code=value)
    #     except MarketBondCode.DoesNotExist:
    #         raise serializers.ValidationError("해당 bond_code가 존재하지 않습니다.")
    #     return market_bond.pk

    class Meta:
        model = ET_Bond_Interest
        fields = "__all__"

class ET_Bond_Holding_Serializer(serializers.ModelSerializer):
    def to_representation(self, instance):
        data = super().to_representation(instance)
        bond_info = instance.bond_code
        data.pop('bond_code')
        data['bond_code'] = bond_info.code
        return data

    class Meta:
        model = ET_Bond_Holding
        fields = "__all__"


class Market_Bond_Days_Serializer(serializers.ModelSerializer):
    class Meta:
        model = MarketBondPreDataDays
        fields = '__all__'

class Market_Bond_Weeks_Serializer(serializers.ModelSerializer):
    class Meta:
        model = MarketBondPreDataWeeks
        fields = '__all__'

class Market_Bond_Months_Serializer(serializers.ModelSerializer):
    class Meta:
        model = MarketBondPreDataMonths
        fields = '__all__'