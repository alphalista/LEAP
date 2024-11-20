from rest_framework import viewsets
from .models import Users
from .serializers import UserSerializer


class UserViewSet(viewsets.ModelViewSet):
    queryset = Users.objects.all()
    serializer_class = UserSerializer

    def get_queryset(self):
        user = self.request.query_params.get('user', None)
        if user:
            return self.queryset.filter(user_id=user)
        return self.queryset