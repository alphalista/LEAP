from django.db import models
from django.db.models import UniqueConstraint

# Create your models here.
# Duplicated model from kpaas_rest


class SearchKeyword(models.Model):
    search_keyword = models.CharField(max_length=200, verbose_name="검색 키워드")
    class Meta:
        constraints = [
            UniqueConstraint(fields=["search_keyword"], name="unique_keyword")
        ]

# 네이버 뉴스 API
class NaverNews(models.Model):
    search_keyword = models.ForeignKey(SearchKeyword, on_delete=models.CASCADE)
    title = models.CharField(max_length=200, verbose_name="제목")
    originallink = models.CharField(max_length=200, verbose_name="원본 링크")
    link = models.CharField(max_length=200, verbose_name="링크")
    description = models.TextField(verbose_name="요약")
    pubDate = models.CharField(max_length=200, verbose_name="발행 일자")

    class Meta:
        constraints = [
            UniqueConstraint(fields=["originallink"], name="unique_naver_news")
        ]
