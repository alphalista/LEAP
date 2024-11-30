from django.test import TestCase
from usr.models import Users
from usr.tests import TestUser
from .models import OTC_Bond
import requests
import json
# Create your tests here.

class TestOtcBond(TestCase):
    id_token = TestUser.id_token
    Authorization_header = {'HTTP_Authorization': 'Bearer ' + id_token}
    @classmethod
    def setUpTestData(cls):
        TestUser.setUpTestData()
    def test_user(self):
        self.assertNotEqual(Users.objects.count(), 0) # 유저가 들어가 있는가?
    def test_OtcBondAll(self):
        response = self.client.get('/api/otcbond/otc-bond-all/')
        self.assertEqual(response.status_code, 200)
    def test_Expired(self):
        headers = TestOtcBond.Authorization_header
        response = self.client.get('/api/otcbond/expired/', **headers)
        self.assertEqual(response.status_code, 200)
    def test_holding(self):
        # get Test
        headers = TestOtcBond.Authorization_header
        response = self.client.get('/api/otcbond/holding/', **headers)
        self.assertEqual(response.status_code, 200)
