#!/data/exec/python/bin/python3
# -*- coding: utf-8 -*-
# @Time    : 2020/6/22 9:54
# @Author  : YuZhiYi
# @Email   : yuzhiyi@54.com
import redis


def migrate_key(src,dest,prefix):
    try:
        src_conn = redis.Redis(host=src[0],port=src[1],db=src[2])
        dest_conn = redis.Redis(host=dest[0],port=dest[1],db=dest[2])
    except Exception as e:
        raise  e
    else:
        mig_keys = None
        if prefix:
            mig_keys = src_conn.keys(prefix)
        else:
            mig_keys = src_conn.keys('*')

        for key in mig_keys:
            # 判断key是否存在
            if src_conn.exists(key):
                print(key)
                # 获取key类型
                key_type = src_conn.type(key)
                key_type_str = key_type.decode()
                print(key_type_str)
                # 按类型迁移 key
                if key_type_str == 'string':
                    s_key = src_conn.get(key)
                    dest_conn.set(key,s_key)
                elif key_type_str == 'list':
                    l_key = src_conn.lrange(key,0,-1)
                    if dest_conn.exists(key):
                        dest_conn.delete(key)
                    for k in l_key:
                        dest_conn.lpush(key,k)
                elif key_type_str == 'set':
                    s_key = src_conn.smembers(key)
                    if dest_conn.exists(key):
                        dest_conn.delete(key)
                    for k in s_key:
                        dest_conn.sadd(key,k)
                elif key_type_str == 'zset':
                    z_key = src_conn.zrange(key,0,-1,withscores=True)
                    if dest_conn.exists(key):
                        dest_conn.delete(key)
                    print(z_key)
                    mapping = { k:v  for k,v in z_key}
                    # for k in z_key:
                    #     print(k)
                    dest_conn.zadd(key,mapping)
                elif key_type_str == 'hash':
                    h_key = src_conn.hgetall(key)
                    for h,v in h_key.items():
                        dest_conn.hset(key,h,v)
                else:
                    pass
            print()





if __name__ == '__main__':
    SRC_HOST_PORT_DB = ('192.168.8.239',6379,4)
    DEST_HOST_PORT_DB = ('192.168.8.239',6379,6)
    KEY_PREFIX = None
    #KEY_PREFIX = 'WSHY*'

    migrate_key(SRC_HOST_PORT_DB,DEST_HOST_PORT_DB,KEY_PREFIX)