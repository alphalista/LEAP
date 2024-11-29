from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import Users
from .serializers import UserSerializer
from django.contrib.auth.models import User
from .permissions import IsOwner
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication

class UsersViewSet(viewsets.ModelViewSet):
    queryset = Users.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated, IsOwner]

    def get_queryset(self):
        return self.queryset.filter(user_id=self.request.user.user_id)


