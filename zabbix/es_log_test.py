#!/data/exec/python/bin/python3
# -*- coding: utf-8 -*-
# @Time    : 2019/11/28 9:46
# @Author  : YuZhiYi
# @Email   : yuzhiyi@54.com
import sys

from elasticsearch import Elasticsearch


# 系统传入参数 [索引名,字段名,字段值,查询间隔]
# 返回的输出是 匹配的结果数
# 用于后续zabbix中日志监控脚本



def es_log_count_search(idx,key,value,interval="1h"):
    '''
    :param idx: 索引名 
    :param key:  查询字段
    :param value:  匹配的值 
    :param interval:  查询的时间周期
    :return: 
    '''
    es = Elasticsearch(['ops-es.00joy.com'], scheme='https', port=443)
    body = {
        "query": {
            "bool": {
                "must": [
                    {"match": {key: value}},
                    # {"match": {"content": "Elasticsearch"}}
                ],
                "filter": [
                    {"range": {"@timestamp": {
                        # "gte": "2019-11-21T00:00:00.000+0800",
                        # "lt": "2018-06-15T13:00:00.000+0800"
                        "gt": "now-" + interval
                        # "gt": "2014-01-01 00:00:00",
                        # "lt": "2014-01-01 00:00:00||+1M"     #加一个月
                    }}}
                ]
            }
        }
    }
    # ret = es.search(index='loginprocess', )
    ret = es.count(index=idx, body=body)
    print(ret['count'])

# ret = es.search(index='loginprocess', body=body,size=100)
# pprint.pprint(ret)
# for i in ret['hits']['hits']:
#     print(i)


if __name__ == '__main__':
    idx = sys.argv[1]
    key = sys.argv[2]
    value =sys.argv[3]
    interval = sys.argv[4]
    es_log_count_search(idx,key,value,interval)
    # es_log_count_search('loginprocess', "channel_id", "116", "24h")
