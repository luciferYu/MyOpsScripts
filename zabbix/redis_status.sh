#!/bin/bash
REDISCLI="/usr/bin/redis-cli"
HOST="10.0.1.12"
PORT=6379
PASS="1Tn6xdR3X5"

if [[ $# == 1 ]];then
    case $1 in
        version)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info server | grep -w "redis_version" | awk -F':' '{print $2}'`
            echo $result
        ;;
        uptime)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info server | grep -w "uptime_in_seconds" | awk -F':' '{print $2}'`
            echo $result
        ;;
        connected_clients)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info clients | grep -w "connected_clients" | awk -F':' '{print $2}'`
            echo $result
        ;;
        blocked_clients)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info clients | grep -w "blocked_clients" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info memory | grep -w "used_memory" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_rss)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info memory | grep -w "used_memory_rss" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_peak)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info memory | grep -w "used_memory_peak" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_lua)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info memory | grep -w "used_memory_lua" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_cpu_sys)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info cpu | grep -w "used_cpu_sys" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_cpu_user)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info cpu | grep -w "used_cpu_user" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_cpu_sys_children)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info cpu | grep -w "used_cpu_sys_children" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_cpu_user_children)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info cpu | grep -w "used_cpu_user_children" | awk -F':' '{print $2}'`
            echo $result
        ;;
        rdb_last_bgsave_status)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info Persistence | grep -w "rdb_last_bgsave_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        aof_last_bgrewrite_status)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info Persistence | grep -w "aof_last_bgrewrite_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        aof_last_write_status)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info Persistence | grep -w "aof_last_write_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        keyspace_hits)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info Stats | grep -w "keyspace_hits" | awk -F':' '{print $2}'`
            echo $result
        ;;
        keyspace_misses)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info Stats | grep -w "keyspace_misses" | awk -F':' '{print $2}'`
            echo $result
        ;;
        keyspace_hit_rate)
            hits=`$REDISCLI -h $HOST -a $PASS -p $PORT info Stats | grep -w "keyspace_hits" | awk -F':' '{print $2}'| tr -d "\r"`
            misses=`$REDISCLI -h $HOST -a $PASS -p $PORT info Stats | grep -w "keyspace_misses" | awk -F':' '{print $2}'| tr -d "\r"`
            result=$(echo "$hits/($hits+$misses)"|bc -l|awk '{printf "%.2f", $0}')
            echo $result
        ;;
        total_net_input_bytes)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info Stats | grep -w "total_net_input_bytes" | awk -F':' '{print $2}'`
            echo $result
        ;;
        total_net_output_bytes)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info Stats | grep -w "total_net_output_bytes" | awk -F':' '{print $2}'`
            echo $result
        ;;
        *)
            echo -e "\033[33mUsage: $0 {connected_clients|blocked_clients|used_memory|used_memory_rss|used_memory_peak|used_memory_lua|used_cpu_sys|used_cpu_user|used_cpu_sys_children|used_cpu_user_children|rdb_last_bgsave_status|aof_last_bgrewrite_status|aof_last_write_status|keyspace_hits|keyspace_misses|keyspace_hit_rate|total_net_input_bytes|total_net_output_bytes}\033[0m"
        ;;
    esac
elif [[ $# == 2 ]];then
    case $2 in
        keys)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info | grep -w "$1" | grep -w "keys" | awk -F'=|,' '{print $2}'`
            echo $result
        ;;
        expires)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info | grep -w "$1" | grep -w "keys" | awk -F'=|,' '{print $4}'`
            echo $result
        ;;
        avg_ttl)
            result=`$REDISCLI -h $HOST -a $PASS -p $PORT info | grep -w "$1" | grep -w "avg_ttl" | awk -F'=|,' '{print $6}'`
            echo $result
        ;;
        *)
            echo -e "\033[33mUsage: $0 {db0 keys|db0 expires|db0 avg_ttl}\033[0m" 
        ;;
    esac
fi
