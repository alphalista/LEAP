from rest_framework import serializers
from .models import (
    SearchKeyword,
    NaverNews,
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


    def create(self, validated_data):
        # validated_data가 리스트가 아닐 경우, 리스트로 변환

        if isinstance(validated_data, bytes):
            validated_data = validated_data.decode('utf-8')

        # If decoded data is a JSON string, parse it into a dictionary or list
        if isinstance(validated_data, str):
            import json
            validated_data = json.loads(validated_data)

        if not isinstance(validated_data, list):
            validated_data = [validated_data]

        created_objects = []

        for data in validated_data:
            obj, created = NaverNews.objects.get_or_create(
                originallink=data.get('originallink'),
                search_keyword=data.get('search_keyword'),
                defaults=data
            )
            created_objects.append(obj)

        return created_objects


    @classmethod
    def remove_duplicates(cls, items):
        existing_links = set(NaverNews.objects.values_list("originallink", flat=True))
        return [item for item in items if item["originallink"] not in existing_links]
