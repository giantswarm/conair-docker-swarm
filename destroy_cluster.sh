#!/bin/sh

set -eu

die () {
    echo >&2 "$@"
    exit 1
}

[ $EUID = 0 ] || die "This script must be run as root"

conair rm swarm-mgr0
conair rm swarm-mgr1
conair rm swarm-mgr2
conair rm swarm-node0
conair rm swarm-node1
conair rm swarm-node2

conair rmi swarm-node
conair rmi swarm-mgr
