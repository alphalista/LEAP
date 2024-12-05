# Create your tasks here


from celery import shared_task
from marketbond.kib_api.collect_kis_data import CollectMarketBond, CollectMarketCode
from marketbond.models import MarketBondCode, MarketBondIssueInfo, MarketBondInquirePrice, MarketBondInquireAskingPrice, \
    MarketBondCmb, MarketBondPreDataDays, MarketBondPreDataMonths, MarketBondPreDataWeeks, MarketBondTrending, MarketBondHowManyInterest, \
    ET_Bond_Holding, ET_Bond_Expired
from django.db import transaction

from .serializer import MarketBondIssueInfoSerializer, MarketBondInquirePriceSerializer, \
    MarketBondInquireAskingPriceSerializer

from django.utils import timezone
from datetime import timedelta
import datetime


@shared_task()
def market_bond_code_info():
    print('start')
    collector = CollectMarketCode()
    collector.store_market_codes()
    print('market codes')


@shared_task(rate_limit='18/s')
def fetch_market_bond_issue_info(pdno):
    try:
        print(pdno, 'issue')
        code = MarketBondCode.objects.filter(code=pdno).first()
        collector = CollectMarketBond(pdno=pdno, bond_code=code)
        collector.store_market_bond_issue_info()
        print('done issue')
    except Exception as e:
        print(e)

@shared_task()
def market_bond_issue_info():
    try:
        pdno_list = list(MarketBondCode.objects.values_list('code', flat=True))
        for pdno in pdno_list:
            fetch_market_bond_issue_info.delay(pdno)
    except Exception as e:
        print(e)


@shared_task()
def market_bond_search_info():
    collector = CollectMarketBond('KR6150351E98')
    collector.store_market_bond_search_info()
    print('market bond search info')


@shared_task(rate_limit='9/s')
def fetch_market_bond_inquire_asking_price(pdno):
    try:
        print(pdno, 'asking')
        code = MarketBondCode.objects.filter(code=pdno).first()
        collector = CollectMarketBond(pdno=pdno, bond_code=code)
        collector.store_market_bond_inquire_asking_price()
        print('done asking')
    except Exception as e:
        print(e)


@shared_task()
def market_bond_inquire_asking_price():
    try:
        pdno_list = list(MarketBondCode.objects.values_list('code', flat=True))
        for pdno in pdno_list:
            fetch_market_bond_inquire_asking_price.delay(pdno)
    except Exception as e:
        print(e)

@shared_task()
def market_bond_avg_unit():
    collector = CollectMarketBond('KR6150351E98')
    collector.store_market_bond_avg_unit()
    print('market bond avg unit')


@shared_task(rate_limit='18/s')
def fetch_market_bond_inquire_daily_itemchartprice(pdno):
    try:
        print(pdno, 'daily')
        code = MarketBondCode.objects.filter(code=pdno).first()
        collector = CollectMarketBond(pdno=pdno, bond_code=code)
        collector.store_market_bond_inquire_daily_itemchartprice()
        print('done daily')
    except Exception as e:
        print(e)


@shared_task()
def market_bond_inquire_daily_itemchartprice():
    try:
        pdno_list = list(MarketBondCode.objects.values_list('code', flat=True))
        for pdno in pdno_list:
            fetch_market_bond_inquire_daily_itemchartprice.delay(pdno)  # Use .delay() to enqueue tasks
    except Exception as e:
        print(e)


@shared_task(rate_limit='9/s')
def fetch_market_bond_inquire_price(pdno):
    try:
        print(pdno, 'price')
        code = MarketBondCode.objects.filter(code=pdno).first()
        collector = CollectMarketBond(pdno=pdno, bond_code=code)
        collector.store_market_bond_inquire_price()
        print('done price')
    except Exception as e:
        print(e)

@shared_task()
def market_bond_inquire_price():
    try:
        pdno_list = list(MarketBondCode.objects.values_list('code', flat=True))
        for pdno in pdno_list:
            fetch_market_bond_inquire_price(pdno)  # Use .delay() to enqueue tasks
    except Exception as e:
        print(e)


@shared_task()
def market_bond_inquire_ccnl():
    collector = CollectMarketBond('KR6150351E98')
    collector.store_market_bond_inquire_ccnl()
    print('market bond inquire ccnl')


@shared_task()
def market_bond_inquire_daily_price():
    collector = CollectMarketBond('KR6150351E98')
    collector.store_market_bond_inquire_daily_price()
    print('market bond inquire daily price')


@shared_task()
def market_search_bond_info():
    collector = CollectMarketBond('KR6150351E98')
    collector.store_market_bond_search_info()
    print('market search bond info')


@shared_task()
def handle_combine(pdno):
    try:
        code = MarketBondCode.objects.filter(code=pdno).first()
        if pdno is not None:
            issue_info_data = MarketBondIssueInfo.objects.filter(code=code).first()
            inquire_price_data = MarketBondInquirePrice.objects.filter(code=code).order_by('-id').first()
            inquire_asking_price_data = MarketBondInquireAskingPrice.objects.filter(code=code).order_by('-id').first()

            with transaction.atomic():
                # Check if a record with the same code already exists
                market_bond_c, created = MarketBondCmb.objects.update_or_create(
                    code=code,
                    defaults={
                        'issue_info_data': issue_info_data,
                        'inquire_price_data': inquire_price_data,
                        'inquire_asking_price_data': inquire_asking_price_data,
                    },
                )
            print(pdno, 'combine done')
    except Exception as e:
        print(e)
@shared_task()
def combine():
    try:
        pdno_list = list(MarketBondCode.objects.values_list('code', flat=True))
        for pdno in pdno_list:
            handle_combine.delay(pdno)  # Use .delay() to enqueue tasks
    except Exception as e:
        print(e)


def calculate_avg(mode, instances):
    avg = 0.0
    for instance in instances:
        if mode == 'duration': avg += float(instance.duration)
        elif mode == 'price': avg += float(instance.price)
        else: print('error')
    avg /= len(instances)
    return avg


# 인자 매핑
# int_type: MarketBondIssueInfo 모델의 bond_int_dfrm_mthd_cd
# interest_percentage: MarketBondIssueInfo 모델의 srfc_inrt
# face_value: 10,000으로고정 상세페이지에서는 (계산기에서 해당 인수가 필요하므로 인수로 놔둠)
# YTM: MarketBondInquirePrice 모델의 ernn_rate
# mat_date: MarketBondIssueInfo 모델의 expd_dt
# interest_cycle_period: MarketBondIssueInfo 모델의 int_dfrm_mcnt
def MacDuration(int_type, interest_percentage, face_value, YTM, mat_date, interest_cycle_period):
    """
    :param int_type: 자료형: str, 이자 지급 형태를 말하며, '이표채', '복리채', '할인채' 등등이 들어갑니다.
    :param interest_percentage: 자료형: double, 이자율을 말합니다.
    :param face_value: 자료형: int, 액면가를 말하며, 수량(단위: 천원)일때 수량 * 1000을 한 값입니다.
    :param YTM: 자료형: double, (세전) 수익률을 말합니다.
    :param mat_date: 자료형: str(YYYYmmdd)형식. 예) "20240103", 만기일을 말합니다.
    :param interest_cycle_period: 자료형: int, 이자 지급주기를 말합니다.
    :return: 자료형: double
    """
    # 남은 이자 지급 횟수 계산 (만기일까지)
    today = datetime.datetime.today()
    maturity_date = datetime.datetime(int(mat_date[:4]), int(mat_date[4:6]), int(mat_date[6:]))
    months_to_maturity = (maturity_date.year - today.year) * 12 + (maturity_date.month - today.month)
    remain_count = int(months_to_maturity / interest_cycle_period)

    if ('이표' in int_type or '3' in int_type) and remain_count != 0:
        # 할인율을 분기별로 계산
        cnt_per_year = 12 / interest_cycle_period
        one_plus_YTM = 1 + (YTM / 100 / cnt_per_year)

        # 쿠폰 이자 계산 (분기마다 지급)
        coupon = (interest_percentage / 100) * face_value / cnt_per_year

        now_value = 0  # 현재 가치의 총합
        weight_value = 0  # 가중된 현재 가치의 총합

        # 각 이자 지급 시점에 대한 듀레이션 계산
        for i in range(1, remain_count + 1):
            # 마지막 현금 흐름에는 원금을 포함
            cash_flow = coupon if i < remain_count else (coupon + face_value)

            # 분기별 할인율 적용하여 현재 가치 계산
            coupon_div_ytm = cash_flow / pow(one_plus_YTM, i)

            # 가중치를 연 단위로 조정하여 반영
            weight = i / cnt_per_year
            now_value += coupon_div_ytm
            weight_value += coupon_div_ytm * weight

        # 듀레이션 계산
        mac_duration = weight_value / now_value if now_value != 0 else 0
        return round(mac_duration, 2)
    else:
        # 만기일 까지를 듀레이션으로 보장
        specific_date = datetime.datetime(int(mat_date[:4]), int(mat_date[4:6]), int(mat_date[6:]))
        today = datetime.datetime.today()
        difference = (specific_date - today).days / 365.25
        return round(difference, 2)

# 수정 필요
# 일별/주별/월별 시가/듀레이션 데이터 저장
# TODO 코드 정독 후 수정 필요 -> 장내 채권에 맞도록 코드 수정 요함
@shared_task
def pre_data_pipeline():
    # 오늘의 장내 채권 목록 전부를 가져옴
    # 장내 채권은 기간별 시세 API로 전부 가져옴
    # 장내 채권의 일별 데이터의 경우 MarketBondInquireDailyItemChartPrice 이름으로 디비가 있음
    # 해당 모델은 디비에 듀레이션이 들어가지 않는다는 치명적인 단점이 존재함.
    # 채권 현재가만 들어가 있는 상태.........따로 저장해야하나....?
    # 파이프라인을 갈아엎어야 하나?
    # -> 어쩔 수 없다. 갈아엎자!! ㅅㅂ
    # -----------
    # pipeline start line
    bonds = MarketBondIssueInfo.objects.all() # 장내 채권 모든 채권 발행 정보를 가져옴
    for bond in bonds:
        # 장내 채권 하나씩 for문을 돌림
        # MarketBondPreDataDays 모델의 bond_code는 MarketBondCode의 id 값을 사용합니다.
        # bond.code도 foreign key로 전달 받기 때문에 상관 없음
        # bond_code: id 방식
        # add_date: auto
        # duruation
        # price
        # 특정 장내 채권의 이전 20일 데이터 DB를 가져옴
        pre_data = MarketBondPreDataDays.objects.filter(bond_code=bond.code).order_by('add_date')
        if len(pre_data) >= 20:
            pre_data.first().delete() # 가장 오래된 데이터를 삭제 진행합니다.
        # 이전 데이터 테이블에 오늘 데이터 추가를 진행 but 듀레이션 따로 계산 진행
        # 수익률: 매도 수익률 중 가장 높은 수익률을 기준으로 진행합니다.
        # 듀레이션 계산을 진행합니다.
        asking_instance = MarketBondInquireAskingPrice.objects.get(code=bond.code)
        duration = MacDuration(
            int_type=bond.bond_int_dfrm_mthd_cd,
            interest_percentage=float(bond.srfc_inrt),
            face_value=10000,
            YTM=float(asking_instance.seln_ernn_rate5),
            mat_date=str(bond.expd_dt),
            interest_cycle_period=int(bond.int_dfrm_mcnt),
        )
        duration = str(duration)
        # 듀레이션 게산 끝
        # price: 일별 현재가의 price를 가져옴
        price = str(MarketBondInquirePrice.objects.get(code=bond.code).bond_prpr)
        MarketBondPreDataDays.objects.create(
            bond_code=MarketBondCode.objects.get(code=bond.code),
            duration=duration,
            price=price,
        )
        # 주별 데이터 추가
        today_weekday = timezone.now().weekday()
        # 월요일로 넘어가기 자정 전에 진행될 것이기 때문에 즉, 일요일에 진행될 것이기에 weekday는 6으로 설정
        if today_weekday == 6: # 일요일이라면 주별 데이터 추가
            # 주말동안에는 어차피 업데이트 안될 것이기 때문에 주말 데이터까지 포함
            seven_days_ago = timezone.now() - timedelta(days=7)
            pre_week_data = MarketBondPreDataDays.objects.filter(bond_code=bond.code).filter(add_date__gte=seven_days_ago).filter(add_date__lte=timezone.now()).order_by('add_date')
            duration_avg = calculate_avg('duration', pre_week_data)
            price_avg = calculate_avg('price', pre_week_data)
            # 주별 데이터 저장
            pre = MarketBondPreDataWeeks.objects.filter(bond_code=bond.code).order_by('add_date')
            if len(pre) >= 8: pre.first().delete() # 8주 데이터 넘어가면 데이터 삭제
            MarketBondPreDataWeeks.objects.create(
                bond_code=MarketBondCode.objects.get(code=bond.code),
                duration=str(duration_avg),
                price=str(price_avg),
            )

        # 월별 데이터 추가
        # 그 다음날이 1일 이라면
        if (timezone.now() + timedelta(days=1)).day == 1:
            now_month = timezone.now().month
            pre_month_data = MarketBondPreDataWeeks.objects.filter(bond_code=bond.code).filter(add_date__month=now_month)
            duration_avg = calculate_avg('duration', pre_month_data)
            price_avg = calculate_avg('price', pre_month_data)
            pre = MarketBondPreDataMonths.objects.filter(bond_code=bond.code).order_by('add_date')
            if len(pre) >= 12: pre.first().delete()  # 12달 데이터 넘어가면 데이터 삭제
            MarketBondPreDataMonths.objects.create(
                bond_code=MarketBondCode.objects.get(code=bond.code),
                duration=str(duration_avg),
                price=str(price_avg),
            )

@shared_task
def marketbond_trending_pipeline(): # 장내 채권 트렌딩 파이프라인 테스크 입니다.
    MarketBondTrending.objects.all().delete()  # 매번 데이터가 바뀌므로 데이터 삭제 진행
    grading = ['AAA', 'AA+', 'AA', 'AA-', 'BBB', '매우낮은위험', '낮은위험', '보통위험']
    ins_count = 10
    howManyInterestLen = len(MarketBondHowManyInterest.objects.filter(danger_degree__in=grading))
    Market_Bond_need = max(0, ins_count - howManyInterestLen)
    instances = MarketBondIssueInfo.objects.filter(nice_crdt_grad_text__in=grading)
    ins = []
    for each in instances:
        ins.append(each.code)
    instances = MarketBondInquireAskingPrice.objects.filter(code__in=ins) # 위험도 추출완료
    for each in instances:
        MarketBondTrending.objects.update_or_create(
            bond_code=each,
            defaults={
                'YTM': each.seln_ernn_rate5
            }
        )
    ins = MarketBondHowManyInterest.objects.filter(danger_degree__in=grading).order_by('-interest')[:howManyInterestLen]
    for each in ins:
        MarketBondTrending.objects.update_or_create(
            bond_code=each,
            defaults={
                'YTM': each.bond_code.YTM
            }
        )

@shared_task
def holding_to_expired():
    expired = ET_Bond_Holding.objects.filter(expire_date__lt=timezone.now())
    for instance in expired:
        ET_Bond_Expired.objects.create(
            user_id=instance.user_id,
            bond_code=instance.bond_code,
        )
    expired.delete()