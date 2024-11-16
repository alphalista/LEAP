from rest_framework import serializers

from .models import (
    SearchKeyword,
    NaverNews,
    UserNewsKeyword
)

class SearchKeywordSerializer(serializers.ModelSerializer):
    class Meta:
        model = SearchKeyword
        fields = "__all__"


class NaverNewsSerializer(serializers.ModelSerializer):
    search_keyword = serializers.PrimaryKeyRelatedField(
        queryset=SearchKeyword.objects.all()
    )

    class Meta:
        model = NaverNews
        fields = "__all__"

    @classmethod
    def remove_duplicates(cls, items):
        existing_links = set(NaverNews.objects.values_list("originallink", flat=True))
        return [item for item in items if item["originallink"] not in existing_links]


class UserNewsSerializer(serializers.ModelSerializer):
    def to_representation(self, instance):
        data = super().to_representation(instance)
        keyword_info = instance.search_keyword
        data.pop("search_keyword")
        data['search_keyword'] = keyword_info.search_keyword
        return data

    class Meta:
        model = UserNewsKeyword
        fields = "__all__"