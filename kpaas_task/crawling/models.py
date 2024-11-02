from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class OTC_Bond(models.Model):
    # trading_company_name = models.CharField(max_length=100)
    # bond_code = models.CharField(max_length=100, primary_key=True)
    # bond_name = models.CharField(max_length=100)
    # danger_degree = models.CharField(max_length=100)
    # pub_date = models.CharField(max_length=100)
    # mat_date = models.CharField(max_length=100)
    # YTM = models.CharField(max_length=100)
    # YTM_after_tax = models.CharField(max_length=100)
    # price_per_10 = models.CharField(max_length=100)
    # bond_type = models.CharField(max_length=100)
    # int_pay_class = models.CharField(max_length=100)
    # int_pay_cycle = models.CharField(max_length=100)
    # interest_percentage = models.CharField(max_length=100)
    # nxt_int_date = models.CharField(max_length=100)
    # expt_income = models.CharField(max_length=100)
    # # duration 추가
    # duration = models.CharField(max_length=100)
    issu_istt_name = models.CharField(max_length=100)
    code = models.CharField(max_length=100, primary_key=True)
    prdt_name = models.CharField(max_length=100)
    nice_crdt_grad_text = models.CharField(max_length=100)
    issu_dt = models.CharField(max_length=100)
    expd_dt = models.CharField(max_length=100)
    YTM = models.CharField(max_length=100)
    YTM_after_tax = models.CharField(max_length=100)
    price_per_10 = models.CharField(max_length=100)
    prdt_type_cd = models.CharField(max_length=100)
    bond_int_dfrm_mthd_cd = models.CharField(max_length=100)
    int_pay_cycle = models.CharField(max_length=100)
    interest_percentage = models.CharField(max_length=100)
    nxtm_int_dfrm_dt = models.CharField(max_length=100)
    expt_income = models.CharField(max_length=100)
    # duration 추가
    duration = models.CharField(max_length=100)
    add_date = models.DateField(auto_now_add=True)

# OTC_Bond_Holding 테이블을 참조하도록하여 rest에서 생성한 같은 테이블을 바라보도록 함
class OTC_Bond_Holding(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    price_per_10 = models.CharField(max_length=100)  # 1만원 채권당 매수단가
    quantity = models.CharField(max_length=100)
    purchase_date = models.CharField(max_length=100)
    expire_date = models.DateField()

    class Meta:
        db_table = 'OTC_Bond_Holding'
        managed = False

class OTC_Bond_Expired(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    class Meta:
        db_table = 'OTC_Bond_Expired'
        managed = False