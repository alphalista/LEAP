from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import Users
from .serializers import UserSerializer
from django.contrib.auth.models import User
from .permissions import IsOwner
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from rest_framework.response import Response
from rest_framework import status

class UsersViewSet(viewsets.ModelViewSet):
    queryset = Users.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated, IsOwner]

    def get_queryset(self):
        return self.queryset.filter(user_id=self.request.user.user_id)

    def update(self, request, *args, **kwargs):
        try:
            user = Users.objects.get(user_id=self.request.user.user_id)
        except Users.DoesNotExist:
            return Response(data={"error": "No Object"}, status=status.HTTP_404_NOT_FOUND)
        serializer = self.get_serializer(user, data=request.data, partial=True)  # 부분 업데이트 허용
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(serializer.data, status=status.HTTP_200_OK)

