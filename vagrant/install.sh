#!/bin/bash
set -e

apt-get update
apt-get install -y --no-install-recommends wget curl python-pip
apt-get clean

wget -qO- https://get.docker.com/ | sh
usermod -aG docker vagrant

pip install docker-compose
