from django.db import models
# from django.contrib.auth.models import User
# Create your models here.

# 유저 앱의 모델과 같은 테이블 바라보게 함
class Users(models.Model):
    user_id = models.CharField(max_length=100, primary_key=True)
    nickname = models.CharField(max_length=100)

    class Meta:
        db_table = 'users'
        managed = False

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
        managed = False

# 장외 관심 채권
class OTC_Bond_Interest(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user_id', 'bond_code')

class OTC_Bond_Holding(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE, related_name='holding_bonds')
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE, related_name='holding_bonds')
    price_per_10 = models.CharField(max_length=100) # 1만원 채권당 매수단가
    quantity = models.CharField(max_length=100)
    purchase_date = models.CharField(max_length=100)
    expire_date = models.DateField()
    class Meta:
        db_table = 'OTC_Bond_Holding'
        unique_together = ('user_id', 'bond_code', 'price_per_10')

class OTC_Bond_Expired(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE, related_name='expired_bonds')
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE, related_name='expired_bonds')
    class Meta:
        db_table = 'OTC_Bond_Expired'

class OtcBondPreDataDays(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE, related_name='pre_data_set')
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)
    class Meta:
        db_table = 'OtcBondPreData'

class OtcBondPreDataWeeks(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE, related_name='pre_data_weeks_set')
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)

    class Meta:
        db_table = 'OtcBondPreDataWeeks'

class OtcBondPreDataMonths(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE, related_name='pre_data_months_set')
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)

    class Meta:
        db_table = 'OtcBondPreDataMonths'