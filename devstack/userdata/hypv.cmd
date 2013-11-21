#!/bin/bash

cd /home/ubuntu/devstack

MY_IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
MY_PASSWORD=ok
MY_TOKEN=ok

cat > localrc <<EOL
HOST_IP=$MY_IP
FLAT_INTERFACE=eth0
FIXED_RANGE=10.4.128.0/20
FIXED_NETWORK_SIZE=4096
FLOATING_RANGE=192.168.42.128/25
MULTI_HOST=1
LOGFILE=/opt/stack/logs/stack.sh.log
ADMIN_PASSWORD=$MY_PASSWORD
MYSQL_PASSWORD=$MY_PASSWORD
RABBIT_PASSWORD=$MY_PASSWORD
SERVICE_PASSWORD=$MY_PASSWORD
SERVICE_TOKEN=$MY_TOKEN
DATABASE_TYPE=mysql
SERVICE_HOST=192.168.42.11
MYSQL_HOST=192.168.42.11
RABBIT_HOST=192.168.42.11
GLANCE_HOSTPORT=192.168.42.11:9292
ENABLED_SERVICES=n-cpu,n-net,n-api,c-sch,c-api,c-vol
EOL

sleep 500 # needs to wait the controller is running...

cd /home/ubuntu/ && chown -R ubuntu:ubuntu devstack/
cd /home/ubuntu/devstack && sudo -u ubuntu ./stack.sh
