from rest_framework.response import Response

from .models import (
    SearchKeyword,
    NaverNews,
    UserNewsKeyword
)

from .serializer import (
    SearchKeywordSerializer,
    NaverNewsSerializer,
    UserNewsSerializer
)
from rest_framework import viewsets, status


# Create your views here.

class SearchKeywordViewSet(viewsets.ModelViewSet):
    queryset = SearchKeyword.objects.all()
    serializer_class = SearchKeywordSerializer


class NaverNewsViewSet(viewsets.ModelViewSet):
    queryset = NaverNews.objects.all()
    serializer_class = NaverNewsSerializer


class UserNewsViewSet(viewsets.ModelViewSet):
    queryset = UserNewsKeyword.objects.all()
    serializer_class = UserNewsSerializer
    def get_queryset(self):
        user = self.kwargs.get('user_id', None)
        if user is not None:
            return UserNewsKeyword.objects.filter(user_id=user)
        return UserNewsKeyword.objects.all()

    def create(self, request, *args, **kwargs):
        data = request.data.copy()
        # user_id: hello2
        # search_keyword: 삼성
        # TODO 만약에 뉴스 테이블에 인스턴스가 없을 경우 -> create
        keyword = data.get('search_keyword', None)
        if keyword is not None:
            # 키워드가 데이터로 날라왔다면
            ins = None
            try:
                ins = SearchKeyword.objects.get(search_keyword=keyword)
            except SearchKeyword.DoesNotExist:
                SearchKeyword.objects.create(search_keyword=keyword)
                ins = SearchKeyword.objects.get(search_keyword=keyword)
            data['search_keyword'] = ins.id
            serializer = UserNewsSerializer(data=data)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response({"ERROR": "body에 keyword가 포함되어있지 않습니다."}, status=status.HTTP_400_BAD_REQUEST)



