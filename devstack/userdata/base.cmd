#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install -y git

cd /home/ubuntu

git clone https://github.com/openstack-dev/devstack.git
