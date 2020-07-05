#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

DH1_IP=$(read_var DH1_IP /vagrant/.env)
MOUNT_POINT_NFS=$(read_var MOUNT_POINT_NFS /vagrant/.env)

echo "[TASK 1] Enabling swarm"; sleep 3
docker swarm init --advertise-addr $DH1_IP

echo "[TASK 2] Add network for monitoring environment "; sleep 3
docker network create --driver overlay monitoring-network

echo "[TASK 3] Inspect of all docker networks"; sleep 3
for net in `docker network ls |grep -v NAME | awk '{print $2}'`;do ipam=`docker network inspect $net --format {{.IPAM}}` && echo $net - $ipam; done

echo "[TASK 4] Docker swarm join-token"; sleep 3
docker swarm join-token manager > $MOUNT_POINT_NFS/docker_swarm_token.txt

echo "[TASK 5] Creating script to add new manager on cluster swarm"; sleep 3
echo '#!/bin/bash' > $MOUNT_POINT_NFS/docker_swarm_token_add_manager.sh
cat $MOUNT_POINT_NFS/docker_swarm_token.txt | grep docker | sed -e "s/^.*docker/docker/" >> $MOUNT_POINT_NFS/docker_swarm_token_add_manager.sh
rm -f $MOUNT_POINT_NFS/docker_swarm_token.txt