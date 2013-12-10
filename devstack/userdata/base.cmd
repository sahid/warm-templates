#!/bin/bash

apt-get update
apt-get upgrade -y

add-apt-repository -y cloud-archive:havana
apt-get update
apt-get install -y git

cd /home/ubuntu

git clone https://github.com/openstack-dev/devstack.git
