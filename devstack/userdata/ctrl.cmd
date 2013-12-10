#!/bin/bash

cd /home/ubuntu/devstack

MY_IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
MY_PASSWORD=password
MY_TOKEN=token
MY_LIBVIRT_TYPE=kvm
MY_INTERFACE=eth0

cat > localrc <<EOL
ADMIN_PASSWORD=$MY_PASSWORD
MYSQL_PASSWORD=$MY_PASSWORD
RABBIT_PASSWORD=$MY_PASSWORD
SERVICE_PASSWORD=$MY_PASSWORD
SERVICE_TOKEN=$MY_TOKEN

HOST_IP=$MY_IP
FLAT_INTERFACE=$MY_INTERFACE

ENABLE_TENANT_TUNNELS=True

LIBVIRT_TYPE=$MY_LIBVIRT_TYPE

VNCSERVER_LISTEN=0.0.0.0

disable_service n-net
disable_service n-cpu
enable_service q-svc
enable_service q-agt
enable_service q-l3
enable_service q-meta
enable_service q-dhcp
enable_service neutron
EOL


cd /home/ubuntu/ && chown -R ubuntu:ubuntu devstack/
cd /home/ubuntu/devstack && sudo -u ubuntu ./stack.sh
