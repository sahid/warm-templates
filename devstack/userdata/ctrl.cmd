#!/bin/bash

cd /home/ubuntu/devstack

MY_IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
MY_PASSWORD=password
MY_TOKEN=token
MY_LIBVIRT_TYPE=kvm

cat > localrc <<EOL
ADMIN_PASSWORD=$MY_PASSWORD
MYSQL_PASSWORD=$MY_PASSWORD
RABBIT_PASSWORD=$MY_PASSWORD
SERVICE_PASSWORD=$MY_PASSWORD
SERVICE_TOKEN=$MY_TOKEN

HOST_IP=$MY_IP

ENABLE_TENANT_TUNNELS=True

Q_AGENT_EXTRA_AGENT_OPTS=(tunnel_type=gre)
Q_AGENT_EXTRA_OVS_OPTS=(tenant_network_type=gre)
Q_SRV_EXTRA_OPTS=(tenant_network_type=gre)
Q_USE_NAMESPACE=True
Q_USE_SECGROUP=True

LIBVIRT_TYPE=$MY_LIBVIRT_TYPE

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
