#!/bin/bash

# deps needs and not installed by devstack...
apt-get install -y build-essential python-dev

cd /home/ubuntu/devstack

MY_IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
MY_PASSWORD=password
MY_TOKEN=token
MY_CONTROLLER=192.168.42.11

cat > localrc <<EOL
ADMIN_PASSWORD=$MY_PASSWORD
MYSQL_PASSWORD=$MY_PASSWORD
RABBIT_PASSWORD=$MY_PASSWORD
SERVICE_PASSWORD=$MY_PASSWORD
SERVICE_TOKEN=$MY_TOKEN

HOST_IP=$MY_IP
LOGFILE=/opt/stack/logs/stack.sh.log

ENABLED_SERVICES=n-cpu,rabbit,neutron,q-agt

ENABLE_TENANT_TUNNELS=True

Q_AGENT_EXTRA_AGENT_OPTS=(tunnel_type=gre)

Q_DHCP_EXTRA_DHCP_OPTS=(dhcp_agents_per_network=1)
Q_AGENT_EXTRA_OVS_OPTS=(tenant_network_type=gre)
Q_USE_NAMESPACE=True
Q_USE_SECGROUP=True

SERVICE_HOST=$MY_CONTROLLER
MYSQL_HOST=$MY_CONTROLLER
RABBIT_HOST=$MY_CONTROLLER
Q_HOST=$MY_CONTROLLER
GLANCE_HOSTPORT=$MY_CONTROLLER:9292
EOL

sleep 350 # needs to wait the controller is running...

cd /home/ubuntu/ && chown -R ubuntu:ubuntu devstack/
cd /home/ubuntu/devstack && sudo -u ubuntu ./stack.sh
