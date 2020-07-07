#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}


DATADIR=$(read_var DATADIR /vagrant/.env)

echo "[TASK 1] Install nfs-utils ."; sleep 3
dnf install -y nfs-utils

echo "[TASK 2] Create a share data directory to docker files."; sleep 3
mkdir -p $DATADIR

echo "[TASK 3] Configuring nfs service."; sleep 3
echo "$DATADIR/ *(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports
exportfs -ar

echo "[TASK 4] Enabling nfs service on boot and start it now."; sleep 3
systemctl enable --now nfs-server
systemctl status nfs-server

echo "[TASK 5] Creating firewalls roles."; sleep 3
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
