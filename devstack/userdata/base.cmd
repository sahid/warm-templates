#!/bin/bash

cat > /etc/apt/sources.list.d/cloudarchive-havana.list <<EOL
deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main
deb-src http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main
EOL

apt-get update
#apt-get upgrade -y --force-yes
apt-get install -y git

cd /home/ubuntu

git clone https://github.com/openstack-dev/devstack.git
