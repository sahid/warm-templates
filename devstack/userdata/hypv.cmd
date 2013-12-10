#!/bin/bash

# deps needs and not installed by devstack...
apt-get install -y build-essential python-dev

cd /home/ubuntu/devstack

MY_IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
MY_PASSWORD=password
MY_TOKEN=token
MY_CONTROLLER=192.168.42.11
MY_INTERFACE=eth0

cat > localrc <<EOL
ADMIN_PASSWORD=$MY_PASSWORD
MYSQL_PASSWORD=$MY_PASSWORD
RABBIT_PASSWORD=$MY_PASSWORD
SERVICE_PASSWORD=$MY_PASSWORD
SERVICE_TOKEN=$MY_TOKEN

HOST_IP=$MY_IP
FLAT_INTERFACE=$MY_INTERFACE

LOGFILE=/opt/stack/logs/stack.sh.log
VNCSERVER_LISTEN=0.0.0.0

ENABLED_SERVICES=n-cpu,rabbit,neutron,q-agt

ENABLE_TENANT_TUNNELS=True

Q_AGENT_EXTRA_AGENT_OPTS=(tunnel_type=gre)

SERVICE_HOST=$MY_CONTROLLER
MYSQL_HOST=$MY_CONTROLLER
RABBIT_HOST=$MY_CONTROLLER
Q_HOST=$MY_CONTROLLER
GLANCE_HOSTPORT=$MY_CONTROLLER:9292
EOL

cat > local.conf <<EOL
[[post-config|\$NOVA_CONF]]
[DEFAULT]
vnc_enabled=True
#vnc_keymap=fr
EOL

sleep 350 # needs to wait the controller is running...

cd /home/ubuntu/ && chown -R ubuntu:ubuntu devstack/
cd /home/ubuntu/devstack && sudo -u ubuntu ./stack.sh
