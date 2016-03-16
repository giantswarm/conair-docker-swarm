#!/bin/sh

set -eu

die () {
    echo >&2 "$@"
    exit 1
}

[ $EUID = 0 ] || die "This script must be run as root"

HERE=$(pwd)

cd $HERE/manager-bootstrap
conair build swarm-mgr-bootstrap
conair run swarm-mgr-bootstrap swarm-mgr0
while [ "$(conair ip swarm-mgr0)" = "" ]
do
    sleep 1
done
echo $(conair ip swarm-mgr0)

BOOTSTRAP_IP=$(conair ip swarm-mgr0)

cd $HERE/manager
sed -i "s/\b192.168.13.[0-9]\{1,3\}\b/${BOOTSTRAP_IP}/g" config/consul.service
conair build swarm-mgr
conair run swarm-mgr swarm-mgr1
conair run swarm-mgr swarm-mgr2

cd $HERE/node
sed -i "s/\b192.168.13.[0-9]\{1,3\}\b/${BOOTSTRAP_IP}/g" config/consul.service
sed -i "s/\b192.168.13.[0-9]\{1,3\}\b/${BOOTSTRAP_IP}/g" config/docker.service
conair build swarm-node
conair run swarm-node swarm-node0
conair run swarm-node swarm-node1
conair run swarm-node swarm-node2
