from rest_framework import serializers

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
    class Meta:
        model = MarketBondCmb
        fields = "__all__"


class ClickCountSerializer(serializers.ModelSerializer):
    market_bond_code = MarketBondCodeSerializer(read_only=True)
    class Meta:
        model = ClickCount
        fields = "__all__"
