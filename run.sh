#!/bin/bash
set -euo pipefail

apt-get update && apt-get install -y linux-headers-$(uname -r)
modprobe wireguard
wg-quick up $INTERFACE

if [[ -n $NAMESERVER ]]
then
    echo TEST
    #echo $NAMESERVER > /etc/resolv.conf
fi

echo "Entering eternal loop, goodbye ,o/"

# If our container is terminated or interrupted, we'll be tidy and bring down
# the vpn
trap finish TERM INT

while sleep 60; do
	date
	wg show
done
