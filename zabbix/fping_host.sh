#!/bin/bash
#ping status
#auth zhiyi 20191113
#this script use to zabbix-agent ping other host
#./fping_host delayed www.baidu.com
#./fping_host status www.baidu.com
metric=$1
ip=$2
result_path=/usr/local/zabbix/scripts/result/
#tmp_file=/tmp/fping_${ip}_status.txt
#fping -q -c3 "$ip" -an > $tmp_file
 
if [ ! -d $result_path ];then
   mkdir $result_path
   chown -R zabbix:zabbix $result_path
fi

case $metric in
   delayed)
          output=$(cat ${result_path}delayed_${2}.txt|awk -F '/' '{print $8}')
          if [ "$output" == "" ];then
             echo -1 
          else
             echo $output
          fi
          /usr/sbin/fping -q -p500 -c110 $2 > ${result_path}delayed_${2}.txt 2>&1 &
        ;;
   status)
          output=$(cat ${result_path}status_${2}.txt|awk -F '/' '{print $4}')
          if [ "$output" == "" ];then
             echo 0
          else
             echo $output
          fi
          /usr/sbin/fping -q -p500 -c110 $2  > ${result_path}status_${2}.txt 2>&1 &
        ;;
   loss)
          output=$(cat ${result_path}loss_${2}.txt |awk -F '/' '{print $5}'|awk -F '%' '{print $1}')
          if [ "$output" == "" ];then
             echo 100 
          else
             echo $output
          fi
          /usr/sbin/fping -q -p500 -c110 $2 > ${result_path}loss_${2}.txt 2>&1 &
        ;;
         *)
          echo -e "\e[033mUsage: sh  $0 [delayed|loss|status]\e[0m"
   
esac

