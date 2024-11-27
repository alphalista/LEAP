from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import Users, Profile
from .serializers import UserSerializer, ProfileSerializer
from django.contrib.auth.models import User
from .permissions import IsOwner
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication

class UsersViewSet(viewsets.ModelViewSet):
    authentication_classes = []
    queryset = Users.objects.all()
    serializer_class = UserSerializer

    def get_queryset(self):
        user = self.request.query_params.get('user', None)
        if user:
            return self.queryset.filter(user_id=user)
        return self.queryset

class UserViewSet(viewsets.ModelViewSet):
    authentication_classes = [JWTStatelessUserAuthentication]
    queryset = User.objects.all()
    serializer_class = UserSerializer

class ProfileViewSet(viewsets.ModelViewSet):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsOwner]
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
