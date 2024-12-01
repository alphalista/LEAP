# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
from calendar import month

from django_celery_results.utils import now_localtime
# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import datetime
from dateutil.relativedelta import relativedelta
# import mysql.connector
from twisted.spread.pb import portno
import os, sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../')))
import crawling.OTC_bond_scrapy.django_setup
from crawling.models import OTC_Bond
from asgiref.sync import sync_to_async
from django.utils import timezone

class OtcBondScrapyPipeline:
    async def process_item(self, item, spider):
        if spider.name == 'miraeassetSpider' or spider.name == 'shinhanSpider' or spider.name == 'daishinSpider' or spider.name == 'kiwoomSpider':
            pub_date = item['pub_date']
            mat_date = item['mat_date']
            int_cycle = item['int_pay_cycle']
            # 다음 이자 지급일 추가
            if spider.name != 'kiwoomSpider':
                item['nxt_int_date'] = self.nxt_int_date(pub_date, mat_date, int_cycle)
            try:
                item['expt_income'] = str(self.expt_money(float(item['price_per_10']), float(item['interest_percentage']), item['nxt_int_date'].replace('.', ''),
                                                      mat_date.replace('.', ''), int(int_cycle)))
            except ValueError:
                item['expt_income'] = '측정불가'
            item['duration'] = self.MacDuration(
                item['int_pay_class'],
                float(item['interest_percentage']),
                10000,
                float(item['YTM']),
                mat_date.replace('.', ''),
                int(int_cycle)
            )
            # django db 연관
            # 날짜도 업데이트
            await sync_to_async(OTC_Bond.objects.update_or_create)(
                code=item['bond_code'],  # pk로 설정된 필터 조건
                defaults={  # 업데이트 또는 생성할 데이터
                    'issu_istt_name': item['trading_company_name'],
                    'prdt_name': item['bond_name'],
                    'nice_crdt_grad_text': item['danger_degree'],
                    'issu_dt': item['pub_date'],
                    'expd_dt': item['mat_date'],
                    'YTM': item['YTM'],
                    'YTM_after_tax': item['YTM_after_tax'],
                    'price_per_10': item['price_per_10'],
                    'prdt_type_cd': item['bond_type'],
                    'bond_int_dfrm_mthd_cd': item['int_pay_class'],
                    'int_pay_cycle': item['int_pay_cycle'],
                    'interest_percentage': item['interest_percentage'],
                    'nxtm_int_dfrm_dt': item['nxt_int_date'],
                    'expt_income': item['expt_income'],
                    'duration': item['duration'],
                    'add_date': timezone.now()
                }
            )

        return item

    # 다음 이자 지급일
    def nxt_int_date(self, pub_date, mat_date, int_cycle):
        pub_date = datetime.datetime(int(pub_date[:4]), int(pub_date[4:6]), int(pub_date[6:]))
        mat_date = datetime.datetime(int(mat_date[:4]), int(mat_date[4:6]), int(mat_date[6:]))
        int_cycle = relativedelta(months=int(int_cycle))
        nxt_date = (pub_date + int_cycle)
        while nxt_date < datetime.datetime.now():
            nxt_date += int_cycle
        if nxt_date > mat_date:
            nxt_date = mat_date.strftime("%Y%m%d")
        nxt_date = nxt_date.strftime("%Y%m%d")
        return nxt_date

    def interest_money(self, face_value, percent, int_cycle):
        return face_value * (percent * 0.01) / (12 / int_cycle)

    # 예상 세후 수익금을 계산하는 함수 입니다.
    # price_per_10, int: 단위가 천원인 매수 수량이 10개일 때의 기준 가격을 의미합니다.
    # interest_percent, float: 연간 수익율을 의미합니다.
    # nxt_interest_date, str(YYYYmmdd): 다음 이자 지급일을 의미합니다.
    # mat_date str(YYYYmmdd): 만기일을 의미합니다.
    # interest_cycle_period, int: 이자 지급 주기를 의미합니다.
    def expt_money(self, price_per_10, interest_percent, nxt_interest_date, mat_date, interest_cycle_period):
        """
        :param price_per_10, int:
        :param interest_percent float:
        :param nxt_interest_date, str(YYYYmmdd):
        :param mat_date str(YYYYmmdd):
        :param interest_cycle_period, int:
        :return:
        """
        # 매수 수량(단위 천원) 만원 당 계산으로 들어갑니다.
        PUR_CNT = 10
        face_value = PUR_CNT * 1000
        price = price_per_10 * PUR_CNT / 10
        remaining_interest_period = self.get_remaining_interest_period(nxt_interest_date, mat_date, interest_cycle_period)
        interest = self.interest_money(face_value, interest_percent, interest_cycle_period) # 회당 이자
        tot_interest = interest * remaining_interest_period
        tax = interest * 0.154 * remaining_interest_period
        # 지금 대비 수익
        # return round(face_value + tot_interest - tax - price, 2)
        # 만기 수익
        return round(face_value + tot_interest - tax, 2)

    def get_remaining_interest_period(self, next_interest_date, maturity_date, interest_cycle_period):
        count = 0
        # print(int(next_interest_date[:4]), int(next_interest_date[4:6]), 1)
        next_interest_date = datetime.datetime(int(next_interest_date[:4]), int(next_interest_date[4:6]),
                                               1)  # 연, 월, 일 넣는다. 일수는 이자 지급일자와 만기일자는 같기 때문에 1로 가정한다.
        maturity_date = datetime.datetime(int(maturity_date[:4]), int(maturity_date[4:6]), 1)
        interest_cycle_period = relativedelta(months=interest_cycle_period)
        while next_interest_date <= maturity_date:  # 만기 달을 넘어설 때까지 계속 더해나갑니다.
            next_interest_date += interest_cycle_period
            count += 1
        return count

    def duration(self, now_int, pre_int, now_price, pre_price):
        delta_int = now_int - pre_int
        delta_price = now_price - pre_price
        duration = round(-(1 + now_int) / delta_int * delta_price / now_price, 2)
        return str(duration) # 년도만 원한다면

    def MacDuration(self, int_type, interest_percentage, face_value, YTM, mat_date, interest_cycle_period):
        # 남은 이자 지급 횟수 계산 (만기일까지)
        today = datetime.datetime.today()
        maturity_date = datetime.datetime(int(mat_date[:4]), int(mat_date[4:6]), int(mat_date[6:]))
        months_to_maturity = (maturity_date.year - today.year) * 12 + (maturity_date.month - today.month)
        remain_count = int(months_to_maturity / interest_cycle_period)

        if '이표' in int_type and remain_count != 0:
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


