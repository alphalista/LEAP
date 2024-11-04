# Create your tasks here


from celery import shared_task
from marketbond.kib_api.collect_kis_data import CollectMarketBond, CollectMarketCode
from marketbond.models import MarketBondCode, MarketBondIssueInfo, MarketBondInquirePrice, MarketBondInquireAskingPrice, \
    MarketBondCmb

from .serializer import MarketBondIssueInfoSerializer, MarketBondInquirePriceSerializer, \
    MarketBondInquireAskingPriceSerializer


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
            fetch_market_bond_inquire_price.delay(pdno)  # Use .delay() to enqueue tasks
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
    code = MarketBondCode.objects.filter(code=pdno).first()
    if pdno is not None:
        issue_info_data = MarketBondIssueInfo.objects.filter(code=code).first()
        inquire_price_data = MarketBondInquirePrice.objects.filter(code=code).order_by('-id').first()
        inquire_asking_price_data = MarketBondInquireAskingPrice.objects.filter(code=code).order_by('-id').first()

        market_bond_c = MarketBondCmb.objects.create(
            code=code,
            issue_info_data=issue_info_data,
            inquire_price_data=inquire_price_data,
            inquire_asking_price_data=inquire_asking_price_data,
        )
        print(pdno, 'combine done')
@shared_task()
def combine():
    try:
        pdno_list = list(MarketBondCode.objects.values_list('code', flat=True))
        for pdno in pdno_list:
            handle_combine.delay(pdno)  # Use .delay() to enqueue tasks
    except Exception as e:
        print(e)
