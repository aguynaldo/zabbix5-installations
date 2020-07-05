#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

MOUNT_POINT_NFS=$(read_var MOUNT_POIINT_NFS /vagrant/.env)


echo "[TASK 1] Create folders for grafana"; sleep 3
mkdir -p $MOUNT_POINT_NFS/grafana/data && \
chown -R 472:472 $MOUNT_POINT_NFS/grafana/data && \
chmod -R 775 $MOUNT_POINT_NFS/grafana && mkdir -p $MOUNT_POINT_NFS/grafana/certs && \
chown -R 472:472 $MOUNT_POINT_NFS/grafana/certs

echo "[TASK 2] Create folders for externalscripts and alertscripts"; sleep 3
mkdir -p $MOUNT_POINT_NFS/zabbix-server/externalscripts
mkdir -p $MOUNT_POINT_NFS/zabbix-server/alertscripts


echo "[TASK 3] Generating the frontend common.env file"; sleep 3
cd /vagrant
bash gen_frontend_common.sh


echo "[TASK 4]Generating the server common.env file"; sleep 3
bash gen_server_common.sh


echo "[TASK 6]Generating the docker-compose file"; sleep 3
bash gen_docker-compose.sh


echo "[TASK 6] Starting stack on swarm"; sleep 3
cd /vagrant/deploy_zabbix_ha
docker stack deploy -c docker-compose.yaml maratonazabbix
