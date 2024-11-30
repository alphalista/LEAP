from .models import OTC_Bond_Interest, OTC_Bond_Holding, OTC_Bond_Expired, OtcBondPreDataDays, OtcBondPreDataWeeks, \
    OtcBondPreDataMonths, OtcBondTrending
from rest_framework import serializers
import os, sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../kpaas_task/')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../kpaas_task/crawling/')))
from .models import OTC_Bond

class OTC_Bond_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OTC_Bond
        fields = '__all__'

class OTC_Bond_Interest_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OTC_Bond_Interest
        fields = '__all__'

class OTC_Bond_Holding_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OTC_Bond_Holding
        fields = '__all__'

class OTC_Bond_Expired_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OTC_Bond_Expired
        fields = '__all__'

class OTC_Bond_Days_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OtcBondPreDataDays
        fields = '__all__'

class OTC_Bond_Weeks_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OtcBondPreDataWeeks
        fields = '__all__'

class OTC_Bond_Months_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OtcBondPreDataMonths
        fields = '__all__'

class OTC_Bond_Trending_Serializer(serializers.ModelSerializer):
    class Meta:
        model = OtcBondTrending
        fields = '__all__'