#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### ### Setting IP for Swarm
ZABBIX_SRV_IP==$(read_var ZABBIX_SRV_IP /vagrant/.env)

ZBX_HOSTNAME=$(read_var ZBX_HOSTNAME /vagrant/.env)
SRV_BD_IP=$(read_var SRV_BD_IP /vagrant/.env)
ZABBIX_USER=$(read_var ZABBIX_USER /vagrant/.env)
ZABBIX_PASS=$(read_var ZABBIX_PASS /vagrant/.env)
ZABBIX_BD=$(read_var ZABBIX_BD /vagrant/.env)

echo "ZBX_SERVER_HOST=maratonazabbix_$ZBX_HOSTNAME
DB_SERVER_HOST=$SRV_BD_IP
MYSQL_USER=$ZABBIX_USER
MYSQL_PASSWORD=$ZABBIX_PASS
MYSQL_DATABASE=$ZABBIX_BD
PHP_TZ=America/Sao_Paulo
TZ=America/Sao_Paulo
ZBX_SERVER_NAME=Zabbix 5 com docker
ZBX_MEMORYLIMIT=512M
" > /vagrant/maratonazabbix/envs/zabbix-frontend/common.env 

