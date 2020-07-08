#!/bin/bash

### Funçâo para ler as variaveis do arquivo .env
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}


### Definindo as CONSTANTES para configurar o banco de dados
ZABBIX_SERVER_USER=$(read_var ZABBIX_SERVER_USER /vagrant/.env)
ZABBIX_SERVER_PASS=$(read_var ZABBIX_SERVER_PASS /vagrant/.env)
ZABBIX_DB=$(read_var ZABBIX_DB /vagrant/.env)
SRV_DB_IP=$(read_var SRV_DB_IP /vagrant/.env)

echo "Mostrando as constantes"
echo $ZABBIX_DB
echo $ZABBIX_SERVER_USER
echo $ZABBIX_SERVER_PASS
echo $SRV_DB_IP


echo "[TASK 3] Installing zabbix-server"; sleep 3
dnf install -y zabbix-server mysql

echo "[TASK 4] Loading initial database scheme "; sleep 3
zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -h $SRV_DB_IP -u $ZABBIX_SERVER_USER -p$ZABBIX_SERVER_PASS $ZABBIX_DB

echo "[TASK 6]  Checking if database was populate"; sleep 3
mysql -h $SRV_DB_IP -u $ZABBIX_SERVER_USER -p$ZABBIX_SERVER_PASS -e "show tables;" $ZABBIX_DB

echo "[TASK 7] Editing zabbix-server.conf"; sleep 3
cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf_original
sed -i 's/^DBName=zabbix/DBName='$ZABBIX_DB'/' /etc/zabbix/zabbix_server.conf
sed -i 's/^DBUser=zabbix/DBUser='$ZABBIX_SERVER_USER'/' /etc/zabbix/zabbix_server.conf
sed -i 's/^# DBPassword=/DBPassword='$ZABBIX_SERVER_PASS'/' /etc/zabbix/zabbix_server.conf
sed -i 's/^# DBHost=localhost/DBHost='$SRV_DB_IP'/' /etc/zabbix/zabbix_server.conf


echo "[TASK 8] Setting firewall rules"
firewall-cmd --permanent --add-port=10051/tcp
firewall-cmd --reload

echo "[TASK 9] Enable and starting zabbix-server service"; sleep 3
systemctl enable --now zabbix-server

echo "[TASK 10] Checking zabbix-server state"; sleep 3
systemctl status zabbix-server

echo "[TASK 11] Checking logging of zabbix-server"; sleep 3
tail -n50 /var/log/zabbix/zabbix_server.log