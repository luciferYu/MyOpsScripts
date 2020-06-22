#!/bin/bash
yum -y install ncurses-devel
yum -y install unixODBC unixODBC-devel
yum -y  install  gtk*
yum -y install mesa* freeglut*
yum -y install openssl*
yum -y install crypto* 
yum -y install xmlto
yum -y install xz
yum -y install gcc* 
cd /usr/local/src
tar zxvf simplejson-3.5.3.tar.gz
cd simplejson-3.5.3
python setup.py build
python setup.py install
cd /usr/local/src
tar -jxvf wxWidgets-3.0.2.tar.bz2
cd wxWidgets-3.0.2
./configure --with-opengl --enable-debug --enable-unicode
make
make install
cd /usr/local/src
tar -zxvf otp_src_19.1.tar.gz
cd otp_src_19.1
export ERL_TOP=`pwd`
./configure --without-javac
make
make install
cd /usr/local/src
xz -d rabbitmq-server-generic-unix-3.6.5.tar.xz
tar xvf rabbitmq-server-generic-unix-3.6.5.tar
mv rabbitmq_server-3.6.5 ../
ln -s /usr/local/rabbitmq_server-3.6.5/sbin/* /usr/sbin/
mkdir /etc/rabbitmq
/usr/sbin/rabbitmq-server -detached
/usr/sbin/rabbitmq-plugins enable rabbitmq_management
/usr/sbin/rabbitmqctl add_user root fruit@123
/usr/sbin/rabbitmqctl set_permissions -p / root ".*" ".*" ".*"
/usr/sbin/rabbitmqctl  set_user_tags root  administrator

