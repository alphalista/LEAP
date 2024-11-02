import sys, os
from django.utils import timezone

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), './OTC_bond_scrapy')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../crawling')))


import logging
from billiard.context import Process

# from django.conf import settings
from celery import app, shared_task
from celery.utils.log import get_task_logger
import scrapy
from scrapy.crawler import CrawlerProcess, logger
from .OTC_bond_scrapy.spiders import shinhanSpider, miraeassetSpider, daishinSpider, kiwoomSpider
from scrapy.settings import Settings
import django
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../')))
# Django 프로젝트의 설정 파일 경로 설정
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')  # Django 프로젝트의 settings.py 경로로 대체
django.setup()  # Django 앱 로드
from .models import OTC_Bond, OTC_Bond_Holding, OTC_Bond_Expired, OtcBondPreDataDays, OtcBondPreDataWeeks, \
    OtcBondPreDataMonths
from django.apps import apps

from scrapy.utils.project import get_project_settings

from datetime import timedelta

# settings = get_project_settings()
settings = Settings()
os.environ['SCRAPY_SETTINGS_MODULE'] = 'crawling.OTC_bond_scrapy.settings'
settings_module_path = os.environ['SCRAPY_SETTINGS_MODULE']
settings.setmodule(settings_module_path, priority='project')

def crawling_start():
    process = CrawlerProcess(settings)
    process.crawl(miraeassetSpider.MiraeassetspiderSpider)
    process.crawl(shinhanSpider.ShinhanspiderSpider)
    process.crawl(daishinSpider.DaishinspiderSpider)
    process.crawl(kiwoomSpider.KiwoomspiderSpider)
    process.start()

@shared_task
def crawling():
    proc = Process(target=crawling_start)
    proc.start()
    proc.join()


@shared_task
def holding_to_expired():
    expired = OTC_Bond_Holding.objects.filter(expire_date__lt=timezone.now())
    for instance in expired:
        OTC_Bond_Expired.objects.create(
            user_id=instance.user_id,
            bond_code=instance.bond_code,
        )
    expired.delete()

def calculate_avg(mode, instances):
    avg = 0.0
    for instance in instances:
        if mode == 'duration': avg += float(instance.duration)
        elif mode == 'price': avg += float(instance.price)
        else: print('error')
    avg /= len(instances)
    return avg

# 일별/주별/월별 시가/듀레이션 데이터 저장
@shared_task
def pre_data_pipeline():
    # 오늘의 장외 채권 목록 전부를 가져옴
    bonds = OTC_Bond.objects.filter(add_date=timezone.now())
    for bond in bonds:
        pre_data = OtcBondPreDataDays.objects.filter(bond_code=bond.code).order_by('add_date')
        if len(pre_data) >= 20: # 20일 이상 데이터를 가지고 있다면
            pre_data.first().delete() # 가장 오래된 데이터 삭제
        # 이전 데이터 테이블에 오늘 데이터 추가
        OtcBondPreDataDays.objects.create(
            bond_code=bond.code,
            duration=bond.duration,
            price=bond.price_per_10,
        )
        # 주별 데이터 추가
        today_weekday = timezone.now().weekday()
        # 월요일로 넘어가기 자정 전에 진행될 것이기 때문에 즉, 일요일에 진행될 것이기에 weekday는 6으로 설정
        if today_weekday == 6: # 일요일이라면 주별 데이터 추가
            # 주말동안에는 어차피 업데이트 안될 것이기 때문에 주말 데이터까지 포함
            seven_days_ago = timezone.now() - timedelta(days=7)
            pre_week_data = OtcBondPreDataDays.objects.filter(bond_code=bond.code).filter(add_date__gte=seven_days_ago).filter(add_date__lte=timezone.now()).order_by('add_date')
            duration_avg = calculate_avg('duration', pre_week_data)
            price_avg = calculate_avg('price', pre_week_data)
            # 주별 데이터 저장
            pre = OtcBondPreDataDays.objects.filter(bond_code=bond.code).order_by('add_date')
            if len(pre) >= 8: pre.first().delete() # 8주 데이터 넘어가면 데이터 삭제
            OtcBondPreDataWeeks.objects.create(
                bond_code=bond.code,
                duration=str(duration_avg),
                price=str(price_avg),
            )

        # 월별 데이터 추가
        # 그 다음날이 1일 이라면
        if (timezone.now() + timedelta(days=1)).day == 1:
            now_month = timezone.now().month
            pre_month_data = OtcBondPreDataWeeks.objects.filter(bond_code=bond.code).filter(add_date__month=now_month)
            duration_avg = calculate_avg('duration', pre_month_data)
            price_avg = calculate_avg('price', pre_month_data)
            pre = OtcBondPreDataMonths.objects.filter(bond_code=bond.code).order_by('add_date')
            if len(pre) >= 12: pre.first().delete()  # 12달 데이터 넘어가면 데이터 삭제
            OtcBondPreDataMonths.objects.create(
                bond_code=bond.code,
                duration=str(duration_avg),
                price=str(price_avg),
            )
