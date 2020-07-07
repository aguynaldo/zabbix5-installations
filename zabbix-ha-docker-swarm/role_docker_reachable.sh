#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

MOUNT_POINT_NFS=$(read_var MOUNT_POINT_NFS /vagrant/.env)

echo "[TASK 1] Add manager in cluster swarm"; sleep 3
bash $MOUNT_POINT_NFS/docker_swarm_token_add_manager.sh
