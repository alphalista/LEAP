from django.test import TestCase
from .models import MarketBondCode, ET_Bond_Holding
from usr.models import Users
from usr.tests import TestUser
import json

# Create your tests here.

class MarketBondsTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        TestUser.setUpTestData()
        MarketBondCode.objects.create(
            code='KR123',
            name='ytk',
        )
    def test_holding(self):
        # get test
        headers = TestUser.Authorization_header
        response = self.client.get('/api/marketbond/holding/', **headers)
        self.assertEqual(response.status_code, 200)
        # post test
        data = {
            'bond_code': 'KR123',
            'price_per_10': '10233',
            'quantity': '10',
            'expire_date': '2024-11-11',
            'purchase_date': '2024-10-02'
        }
        response = self.client.post('/api/marketbond/holding/', content_type='application/json', data=json.dumps(data), **headers)
        self.assertEqual(response.status_code, 201)
        ins = MarketBondCode.objects.get(code='KR123')
        id = ET_Bond_Holding.objects.get(bond_code=ins).id
        response = self.client.delete(f'/api/marketbond/holding/{id}/', content_type='application/json', **headers)
        self.assertEqual(response.status_code, 204)
