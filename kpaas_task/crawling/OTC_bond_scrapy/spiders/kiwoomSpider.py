import scrapy
import os, sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../')))
from crawling.OTC_bond_scrapy.items import OtcBondScrapyItem
import copy, json

class KiwoomspiderSpider(scrapy.Spider):
    name = "kiwoomSpider"
    allowed_domains = ["www.kiwoom.com"]
    start_urls = ["https://www.kiwoom.com/wm/bnd/od010/getBndOdListJson"]

    def start_requests(self):
        for url in self.start_urls:
            yield scrapy.Request(url=url, method='POST', callback=self.parse)

    def parse(self, response):
        item = OtcBondScrapyItem()
        lists = json.loads(response.body)['result']['g1']
        for it in lists:
            item['trading_company_name'] = '키움 증권'
            item['bond_code'] = it['stk_code']
            item['bond_name'] = it["stk_nm"]
            item['mat_date'] = it["expr_dt"]
            item['YTM'] = it['trde_prft_rt']
            item['YTM_after_tax'] = it['taxa_errt']
            item['price_per_10'] = it['trde_uv']
            item['nxt_int_date'] = it['next_int_paydt']
            url = "https://www.kiwoom.com/wm/bnd/od010/bndOdDtlPop"
            boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
            body = (
                f"--{boundary}\r\n"
                f"Content-Disposition: form-data; name=\"stk_code\"\r\n\r\n"
                f"{it['stk_code']}\r\n"
                f"--{boundary}--\r\n"
            )

            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36',
                'Referer': 'https://www.kiwoom.com/wm/bnd/od010',
                'Content-Type': f"multipart/form-data; boundary={boundary}"
            }
            yield scrapy.Request(url=url, method='POST', headers=headers, body=body, callback=self.detail_parse, meta={'item': copy.deepcopy(item)})
            # print(item)
            # yield item

    def detail_parse(self, response):
        item = response.meta['item']
        item['int_pay_class'] = response.xpath('//*[contains(@class, \'modal-body-container\')]/div/section/div[2]/div/table/tbody/tr[4]/td[2]/text()').extract_first() + '채'
        item['int_pay_cycle'] = response.xpath('//*[contains(@class, \'modal-body-container\')]/div/section/div[2]/div/table/tbody/tr[5]/td[2]/text()').extract_first().replace('개월', '')
        item['bond_type'] = response.xpath('//*[contains(@class, \'modal-body-container\')]/div/section/div[2]/div/table/tbody/tr[1]/td[1]/text()').extract_first()
        item['pub_date'] = response.xpath('//*[contains(@class, \'modal-body-container\')]/div/section/div[2]/div/table/tbody/tr[2]/td[1]/text()').extract_first().strip().replace('.', '')
        item['interest_percentage'] = response.xpath('//*[contains(@class, \'modal-body-container\')]/div/section/div[2]/div/table/tbody/tr[4]/td[1]/text()').extract_first().replace('%', '')
        item['danger_degree'] = response.xpath('//*[contains(@class, \'modal-body-container\')]/div/section/div[2]/div/table/tbody/tr[8]/td[2]/text()').extract_first().replace(' ', '')
        # item['nxt_int_date'] = response.xpath('//*[contains(@class, \'modal-body-container\')]/div/section/div[2]/div/table/tbody/tr[8]/td[2]/text()').extract_first()
        # print(item)
        yield item

