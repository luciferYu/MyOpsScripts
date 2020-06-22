#!/bin/bash
# scp 172.16.6.51:/data/exec/nginx/conf/nginx.conf 172.16.6.52:/data/exec/nginx/conf/
# scp 172.16.6.51:/data/exec/logstash-7.4.0/config/nginx.conf  172.16.6.52:/data/exec/logstash-7.4.0/config
#scp -P 1603 172.16.6.51:/data/exec/nginx/conf/nginx.conf  172.16.6.52:/data/exec/nginx/conf
#scp -P 1603 172.16.6.51:/data/exec/nginx/conf/block_ips.conf  172.16.6.52:/data/exec/nginx/conf
#rsync --exclude=copy_nginx_conf.sh --delete --progress  -avz -e 'ssh -p 1603' 172.16.6.51:/data/exec/nginx/conf/vhost/ 172.16.6.52:/data/exec/nginx/conf/vhost/ 
rsync  --delete --progress  -avz -e 'ssh -p 1603' 172.16.6.51:/data/exec/nginx/conf/ /data/backup/nginx_conf/
rsync  --delete --progress  -avz -e 'ssh -p 1603' /data/backup/nginx_conf/ 172.16.6.52:/data/exec/nginx/conf/
#scp -r /data/exec/nginx/conf/vhost/* 172.16.6.52:/data/exec/nginx/conf/vhost/ 
ssh 172.16.6.52 -p 1603  '/data/exec/nginx/sbin/nginx -s reload'
