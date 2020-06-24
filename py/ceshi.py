#!/data/exec/python/bin/python3
# -*- coding: utf-8 -*-
# @Time    : 2020/6/24 11:16
# @Author  : YuZhiYi
# @Email   : yuzhiyi@54.com
import requests
import json
headers = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'zh-CN,zh;q=0.9',
    'Cache-Control': 'no-cache',
    #'Connection': 'keep-alive',
    'Connection': 'close',
    'Pragma': 'no-cache',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36',
   }

url = 'https://sh-cms-api.00joy.com/game_reserves/get_reserve_user_number'
payload = {"game_id":"FF000001CL01"}
#payload = json.dumps(payload)

print(payload)
#session = requests.session()
resp = requests.post(url=url,headers=headers,data=payload,timeout=1)
print(resp.text)

