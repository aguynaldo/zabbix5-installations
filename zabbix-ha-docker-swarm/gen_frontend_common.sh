#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### ### Setting IP for Swarm
MYSQL_IP=$(read_var MYSQL_IP /vagrant/.env)
ZABBIX_USER=$(read_var ZABBIX_USER /vagrant/.env)
ZABBIX_PASS=$(read_var ZABBIX_PASS /vagrant/.env)
ZABBIX_DB=$(read_var ZABBIX_DB /vagrant/.env)
ZBX_SERVER_NAME=$(read_var ZBX_SERVER_NAME /vagrant/.env)
MOUNT_POINT_NFS=$(read_var MOUNT_POINT_NFS /vagrant/.env)
STACK_NAME=$(read_var STACK_NAME /vagrant/.env)

echo "ZBX_SERVER_HOST=${STACK_NAME}_zabbix-server
DB_SERVER_HOST=$MYSQL_IP
MYSQL_USER=$ZABBIX_USER
MYSQL_PASSWORD=$ZABBIX_PASS
MYSQL_DATABASE=$ZABBIX_DB
PHP_TZ=America/Sao_Paulo
TZ=America/Sao_Paulo
ZBX_SERVER_NAME=$ZBX_SERVER_NAME
ZBX_MEMORYLIMIT=512M
" > $MOUNT_POINT_NFS/docker-files/envs/zabbix-frontend/common.env 

