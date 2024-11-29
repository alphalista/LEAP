from rest_framework import serializers, viewsets
from .models import Users
from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = '__all__'


class UserSerializerWithToken(UserSerializer):
    class Meta:
        model = User
        fields = '__all__'
