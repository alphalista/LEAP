from rest_framework import serializers, viewsets
from .models import Users, Profile
from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = '__all__'


class UserSerializerWithToken(UserSerializer):
    class Meta:
        model = User
        fields = '__all__'

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = '__all__'