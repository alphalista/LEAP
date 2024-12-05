from django.db import models
# from django.contrib.auth.models import User
from usr.models import Users
# Create your models here.


class OTC_Bond(models.Model):
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
    class Meta:
        db_table = 'crawling_otc_bond'
        # managed = False

# 장외 관심 채권
class OTC_Bond_Interest(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user_id', 'bond_code')
        db_table = 'OTC_Bond_Interest'

class OTC_Bond_Holding(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    price_per_10 = models.CharField(max_length=100) # 1만원 채권당 매수단가
    quantity = models.CharField(max_length=100)
    purchase_date = models.CharField(max_length=100)
    expire_date = models.DateField()
    class Meta:
        db_table = 'OTC_Bond_Holding'
        unique_together = ('user_id', 'bond_code', 'price_per_10')
        # managed = False

class OTC_Bond_Expired(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    class Meta:
        db_table = 'OTC_Bond_Expired'
        # managed = False

class OtcBondPreDataDays(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)
    class Meta:
        db_table = 'OtcBondPreData'
        # managed = False

class OtcBondPreDataWeeks(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)

    class Meta:
        db_table = 'OtcBondPreDataWeeks'
        # managed = False

class OtcBondPreDataMonths(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)

    class Meta:
        db_table = 'OtcBondPreDataMonths'
        # managed = False


class HowManyInterest(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    interest = models.IntegerField()
    danger_degree = models.CharField(max_length=100)

    class Meta:
        db_table = 'HowManyInterest'
        # managed = False

class OtcBondTrending(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    bond_name = models.CharField(max_length=200)
    YTM = models.CharField(max_length=100)
    add_date = models.DateField(auto_now_add=True)

    class Meta:
        db_table = 'OtcBondTrending'
        # managed = False
