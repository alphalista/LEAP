import json

from django.test import TestCase
from .models import SearchKeyword

# Create your tests here.
class NewsTest(TestCase):
    def test_news(self):
        response = self.client.get('/api/news/keyword/')
        self.assertEqual(response.status_code, 200)
        data = {
            "search_keyword": "삼성"
        }
        response = self.client.post('/api/news/keyword/', content_type='application/json', data=json.dumps(data))
        self.assertEqual(response.status_code, 201)
        id = SearchKeyword.objects.get(search_keyword='삼성').id
        response = self.client.delete(f'/api/news/keyword/{id}/')
        self.assertEqual(response.status_code, 204)