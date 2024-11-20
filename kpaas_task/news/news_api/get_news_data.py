import requests
import yaml
import json

class GetNewsData:
    def __init__(self, search_keyword, kw):
        self.config_root = "/code/news/news_api/"
        # self.config_root = ""

        with open(self.config_root + "naver_api.yaml", encoding="UTF-8") as f:
            self._cfg = yaml.load(f, Loader=yaml.FullLoader)
        self._base_headers = {}
        self.query = search_keyword
        self.initialize_key()
        self.kw = kw

    def initialize_key(self):
        self._base_headers = {
            "X-Naver-Client-Id": self._cfg["client_id"],
            "X-Naver-Client-Secret": self._cfg["client_secret"],
        }

    def get_naver_news_data(self):
        url = "https://openapi.naver.com/v1/search/news.json"
        payload = {"query": self.query, "sort": "date", "display": "100"}
        headers = self._base_headers
        res = requests.get(url, headers=headers, params=payload)
        data = res.json()
        lst = data.get('items')
        for item in lst:
            item["search_keyword"] = self.kw.id
        return lst



if __name__ == "__main__":
    s = GetNewsData('삼성')
    res = s.get_naver_news_data()
    print(res)

