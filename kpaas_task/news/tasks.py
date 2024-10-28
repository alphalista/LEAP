# Create your tasks here

from .models import (
    SearchKeyword,
    NaverNews,
)
from .serializer import NaverNewsSerializer
from news.news_api.get_news_data import GetNewsData
from celery import shared_task


@shared_task(rate_limit='10/s')
def fetch_naver_news(kwd):
    try:
        collector = GetNewsData(kwd)
        res = collector.get_naver_news_data()
        serializer = NaverNewsSerializer(res)
        if serializer.is_valid():
            serializer.save()
    except Exception as e:
        print(e)

@shared_task()
def naver_news():
    try:
        kwd_list = list(SearchKeyword.objects.values_list('search_keyword', flat=True))
        for kwd in kwd_list:
            fetch_naver_news(kwd)
    except Exception as e:
        print(e)
