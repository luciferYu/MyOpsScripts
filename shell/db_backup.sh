#!/bin/bash
# auth:yuzhiyi
# date:2020/04/27
# version:0.1.0 
# 功能: 用于远程数据库备份,使用mysqldump 每日一备

# 远程数据库列表
# grant select,reload,super,event on *.* to 'backup'@'172.16.6.%' identified by 'password';
# flush privileges;
# SET @@global.max_allowed_packet=188743680; # 还原时目标机发生过报错，可能是这个变量导致的
# show global variables like 'max_allowed_packet';

BACKUP_DATE=$(date +"%Y-%m-%d")


get_db_list(){
cat << DBLIST
sdk-mysql|172.16.6.200|3306|backup|password|172.16.6.51
log-mysql|172.16.6.202|3306|backup|password|172.16.6.51
DBLIST
	exit 0
}

#远程获取某实例下的所有数据库，并返回
show_databases(){
	ret=$(ssh $1 "/data/exec/mysql/bin/mysql -h$1 -P$2 -u$3 -p$4 -e 'show databases;'|grep -Evi 'information|performance|mysql|database|tmp|innodb|sys' " 2>/dev/null)
        echo $ret
	return
}

create_backup_date_dir(){
	ret=$(ssh $1 "mkdir -p $2")
        return
}


backup_db(){

        echo "backup $db" #after sleep 180 continue"
	#ret=$(ssh $1 "/data/exec/mysql/bin/mysqldump -h$1 -P$2 -u$3 -p$4 -R --master-data=2 --single-transaction  --triggers --routines -A |gzip > /data/backup/mysql/$6/${5}.sql.gz ")
        #ssh 172.16.6.202  "/data/exec/mysql/bin/mysqldump -h172.16.6.202 -P3306 -ubackup -ppassword -R --single-transaction --events  --triggers --set-gtid-purged=OFF  -B game_loginput |gzip > /data/backup/mysql/game_loginput.sql.gz"
	ssh $1 "/data/exec/mysql/bin/mysqldump -h$1 -P$2 -u$3 -p$4 -R --single-transaction --events  --triggers --set-gtid-purged=OFF  -B $5 |gzip > /data/backup/mysql/$6/${5}.sql.gz " 2>/dev/null

        #        sleep 180
	# return 
}



# 主循环 依次获取需要备份的数据库的实例
for line in $(get_db_list);do
	db_host=$(echo $line|awk -F '|' '{print $1}') # 数据库名 与 bashrc内的名字对应
	db_ip=$(echo $line|awk -F '|' '{print $2}') # 数据库ip地址
	db_port=$(echo $line|awk -F '|' '{print $3}') # 数据库端口号
	db_user=$(echo $line|awk -F '|' '{print $4}') # 备份用户名
	db_pwd=$(echo $line|awk -F '|' '{print $5}') # 备份用户密码
	back_host_ip=$(echo $line|awk -F '|' '{print $6}') # 数据库虚拟机所在的宿主机
        echo "正在备份实例 ${db_host} IP:${db_ip}"
        echo "开始创建备份当天文件夹 $BACKUP_DATE"
        backup_base_dir=/data/backup/mysql/$BACKUP_DATE
        create_backup_date_dir $db_ip $backup_base_dir    # 创建当天的的备份文件夹在目标数据库服务器上
	databases=$(show_databases  $db_ip $db_port  $db_user $db_pwd)
        echo $databases
        for db in  $databases;do
        	echo "开始备份数据库: $db"
                backup_db $db_ip $db_port  $db_user $db_pwd $db $BACKUP_DATE 

        done


	# 将数据库里的备份文件夹拷贝到实体机上

       # 新建本地文件夹
       if [ ! -d "/data/backup/mysql/${BACKUP_DATE}/${db_host}" ];then  
	     mkdir -p "/data/backup/mysql/${BACKUP_DATE}/${db_host}"
       fi

       scp -r ${db_ip}:/data/backup/mysql/${BACKUP_DATE} /data/backup/mysql/${BACKUP_DATE}/${db_host}
done
