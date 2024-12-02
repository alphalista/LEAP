from django.test import TestCase

from .models import OTC_Bond_Interest
from .models import OTC_Bond_Holding
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
        OTC_Bond.objects.create(
            YTM='3.11',
            YTM_after_tax='2.63',
            code='KR6029272E17',
            prdt_name='에스케이실트론50-2',
            prdt_type_cd='일반회사채',
            nice_crdt_grad_text='보통위험',
            duration=1.93,
            expt_income='10811.65',
            bond_int_dfrm_mthd_cd='이표채',
            int_pay_cycle='3',
            interest_percentage='4.2640',
            expd_dt='20270129',
            nxtm_int_dfrm_dt='20250129',
            price_per_10='10233',
            issu_dt='20240129',
            issu_istt_name='미래에셋 증권'
        )
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
        headers = TestOtcBond.Authorization_header
        # post Test
        data = {
            'bond_code': 'KR6029272E17',
            'price_per_10': '10233',
            'quantity': '10',
            'expire_date': '2024-11-11',
            'purchase_date': '2024-10-02'
        }
        response = self.client.post('/api/otcbond/holding/', content_type='application/json', data=json.dumps(data), **headers)
        self.assertEqual(response.status_code, 201)
        # GET Test
        response = self.client.get('/api/otcbond/holding/', **headers)
        self.assertEqual(response.status_code, 200)
        # print(response.json())
        # delete Test
        ins = OTC_Bond.objects.get(code='KR6029272E17')
        id = OTC_Bond_Holding.objects.get(bond_code=ins).id
        response = self.client.delete(f'/api/otcbond/holding/{id}/', **headers)
        self.assertEqual(response.status_code, 204)

    def test_Predata(self):
        response = self.client.get('/api/otcbond/days/KR6029272E17/')
        self.assertEqual(response.status_code, 200)
        response = self.client.get('/api/otcbond/weeks/KR6029272E17/')
        self.assertEqual(response.status_code, 200)
        response = self.client.get('/api/otcbond/months/KR6029272E17/')
        self.assertEqual(response.status_code, 200)

    def test_interest(self):
        # POST 요청 Test
        headers = TestOtcBond.Authorization_header
        data = {
            'bond_code': 'KR6029272E17'
        }
        response = self.client.post('/api/otcbond/interest/', content_type='application/json', data=json.dumps(data), **headers)
        self.assertEqual(response.status_code, 201)
        # GET 요청 테스트
        response = self.client.get('/api/otcbond/interest/', **headers)
        self.assertEqual(response.status_code, 200)
        # print(response.json())
        # DELETE 요청테스트
        id = OTC_Bond_Interest.objects.get(bond_code='KR6029272E17').id
        # print(id)
        response = self.client.delete(f'/api/otcbond/interest/{id}/', **headers)
        self.assertEqual(response.status_code, 204)