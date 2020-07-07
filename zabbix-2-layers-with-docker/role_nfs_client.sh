#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### Defining the CONSTANTS to set the database
DATADIR=$(read_var DATADIR /vagrant/.env)
NFS_IP=$(read_var NFS_IP /vagrant/.env)
MOUNT_POINT_NFS=$(read_var MOUNT_POINT_NFS /vagrant/.env)


echo "[TASK 1] Installing nfs-utils"; sleep 3
dnf install -y nfs-utils

echo "[TASK 2] Creating folder to mount nfs shared folder."; sleep 3
mkdir -p $MOUNT_POINT_NFS

echo "[TASK 3] Add mount poing in fstab file."; sleep 3
echo $NFS_IP
echo $DATADIR
echo $MOUNT_POINT_NFS
echo "# 
# Add mount point to nfs-server shared folder.
$NFS_IP:$DATADIR   $MOUNT_POINT_NFS    nfs     defaults    0 0" >> /etc/fstab

echo "[TASK 4] Systemctl daemon-reload."; sleep 3
systemctl daemon-reload

echo "[TASK 5] Mounting all mount points."; sleep 3
cat /etc/fstab
mount -av
df -h

echo "[TASK 6] Testing write in shared folder."; sleep 3
echo "Eu montei" > $MOUNT_POINT_NFS/$HOSTNAME.txt
