#!/data/exec/python/bin/python3
# -*- coding: utf-8 -*-
# @Time    : 2020/6/23 14:04
# @Author  : YuZhiYi
# @Email   : yuzhiyi@54.com
import requests
import json
import time
import asyncio
import uuid
import threading
import multiprocessing
import os


class baseSpider(object):
    def __init__(self):
        self.headers = {
            'Accept': 'application/json, text/plain, */*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Accept-Language': 'zh-CN,zh;q=0.9',
            'Cache-Control': 'no-cache',
            'Connection': 'keep-alive',
            'Pragma': 'no-cache',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36'
        }

        self.session = requests.session()
        self.result = {}


class webSpider(baseSpider):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    async def get_page(self,url,headers=None,params=None,payload=None):
        if headers:
            self.headers.update(headers)
        if not params:
            params = {}

        if not payload:
            payload = {}

        try:
            start_time = time.perf_counter()
            resp = self.session.get(url=url,headers=self.headers,params=params)
            end_time = time.perf_counter()
            used_time = end_time - start_time
            #print(type(resp.text))
            #self.result['body'] = resp.text
            self.result['code'] = resp.status_code
            self.result['used_time'] = used_time
            await asyncio.sleep(0.000001)
        except Exception as e:
            print(e)
            self.result['code'] = 500
            self.result['used_time'] = 0



    # def post_page(self,url=url, headers=headers,params=params data=payload):
    #     pass




async  def req(url,queue):
    ws = webSpider()
    await ws.get_page(url)
    ws.result['uuid'] = uuid.uuid4()
    ws.result['threading'] = '%s' % threading.current_thread()
    queue.put(ws.result)
    await asyncio.sleep(0.000001)

def worker(queue, c):
    url = 'https://xclx.00joy.com'
    loop = asyncio.get_event_loop()
    tasks = []
    for i in range(c):
        task = loop.create_task(req(url,queue))
        tasks.append(task)
    loop.run_until_complete(asyncio.wait(tasks))
    loop.close()


if __name__ == '__main__':
    p_num = 7 # 进程数
    c_num = 1000 # 协程数
    queue = multiprocessing.Manager().Queue(100)
    pool = multiprocessing.Pool(p_num)
    ret = {'count_200': 0, 'total_used_time': 0.0, 'count_none_200': 0, 'count': 0}
    for i in range(p_num):
        pool.apply_async(worker, args=(queue,c_num))
    #run()


    print('start get queue')
    count = 0
    ret = {'code_200':0,'code_none_200':0,'total_used_time':0.0,'count':0}
    while not count >= p_num * c_num:
        value = queue.get()
        if value['code'] == 200:
            ret['code_200'] += 1
        else:
            ret['code_none_200'] += 1
        ret['total_used_time'] += value['used_time']
        ret['count'] += 1
        count += 1

    print('end concurrent')
    ret['avg_used_time'] = ret['total_used_time']/ret['code_200']
    print(ret)
    pool.close()
    pool.join()
    print('over...')

