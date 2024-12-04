from django.db import models
from usr.models import Users

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
    add_date = models.DateField(blank=True, null=True)

# OTC_Bond_Holding 테이블을 참조하도록하여 rest에서 생성한 같은 테이블을 바라보도록 함
class OTC_Bond_Holding(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    price_per_10 = models.CharField(max_length=100)  # 1만원 채권당 매수단가
    quantity = models.CharField(max_length=100)
    purchase_date = models.CharField(max_length=100)
    expire_date = models.DateField()

    class Meta:
        db_table = 'OTC_Bond_Holding'

class OTC_Bond_Expired(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    class Meta:
        db_table = 'OTC_Bond_Expired'

class OtcBondPreDataDays(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)
    class Meta:
        db_table = 'OtcBondPreData'

class OtcBondPreDataWeeks(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)

    class Meta:
        db_table = 'OtcBondPreDataWeeks'

class OtcBondPreDataMonths(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    add_date = models.DateField(auto_now_add=True)
    duration = models.CharField(max_length=100)
    price = models.CharField(max_length=100)

    class Meta:
        db_table = 'OtcBondPreDataMonths'

# 장외 채권 트렌딩 채권 저장 모델입니다. (Managed)
class OtcBondTrending(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    bond_name = models.CharField(max_length=200)
    YTM = models.CharField(max_length=100)
    add_date = models.DateField(auto_now_add=True)

    class Meta:
        db_table = 'OtcBondTrending'

class HowManyInterest(models.Model):
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)
    interest = models.IntegerField()
    danger_degree = models.CharField(max_length=100)

    class Meta:
        db_table = 'HowManyInterest'

# 장외 관심 채권
class OTC_Bond_Interest(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    bond_code = models.ForeignKey(OTC_Bond, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user_id', 'bond_code')
        db_table = 'OTC_Bond_Interest'
