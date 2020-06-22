#!/bin/bash
# auth:yuzhiyi
# date:2020/4/15
# 常用kvm快照命令
#virsh snapshot-create-as 主机名 快照名
#virsh snapshot-list 主机名
#virsh snapshot-revert 主机名 快照名
#virsh snapshot-delete 主机名 快照名
#1 2 * * * /data/scripts/kvm_snapshot.sh > /dev/null 2>&1 &

RESERVE_DAYS=5 #保留快照的天数 会留+1份快照
EXCLUDE='hadoop01|hadoop04'
#for line in $(virsh list|awk 'NR>2'|awk '{print $2}') 
for line in $(virsh list|awk 'NR>2'|awk '{print $2}'|grep -E  -v $EXCLUDE ) 
do
#echo $line
	host=${line} #获取主机
	# 检查快照数目
        snap_list=$(virsh snapshot-list $host|grep $host|awk '{print $1}')
        snap_list_count=`echo $snap_list|sed 's/ /\n/g'|wc -l`
        #echo $snap_list
        #echo $snap_list_count
        if [[ $snap_list_count >  $RESERVE_DAYS ]];then
           #echo '大于'
           ((need_del_snap_count=$snap_list_count-$RESERVE_DAYS))
           del_snap_list=$(echo $snap_list|sed 's/ /\n/g'|head -n $need_del_snap_count)
           for del_snap in $(echo $del_snap_list|sed 's/ /\n/g');do
               echo "即将删除快照 ${del_snap}"
               virsh snapshot-delete $host $del_snap    
           done
        fi

        d=$(date '+%Y_%m_%d_%H_%M') #获取当前时间
        snapshot_name=${host}_${d} #设置快照名
	echo "即将创建快照 ${snapshot_name}"
        virsh snapshot-create-as $host $snapshot_name # 创建快照      

        echo $(virsh snapshot-list $host)
done
