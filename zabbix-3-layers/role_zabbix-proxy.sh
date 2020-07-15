#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

ZABBIX_SRV_IP=$(read_var ZABBIX_SRV_IP /vagrant/.env)

echo "[TASK 1] Install Zabbix Proxy."; sleep 3
dnf install -y zabbix-proxy-sqlite3 zabbix-get zabbix-sender

echo "[TASK 2] Create directory and set permissions for sqlite.db file."; sleep 3
mkdir -p /var/lib/zabbix
chown zabbix. -R /var/lib/zabbix


echo "[TASK 3] Editing zabbix_proxy.conf file"; sleep 3
cp /etc/zabbix/zabbix_proxy.conf /etc/zabbix/zabbix_proxy.conf_original
sed -i 's/^Server=127.0.0.1$/Server='$ZABBIX_SRV_IP'/' /etc/zabbix/zabbix_proxy.conf
sed -i 's/^ServerActive=127.0.0.1$/ServerActive='$ZABBIX_SRV_IP'/' /etc/zabbix/zabbix_proxy.conf
sed -i 's/Hostname=Zabbix proxy/# Hostname=Zabbix proxy/' /etc/zabbix/zabbix_proxy.conf
sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_proxy.conf
sed -i 's+DBName=zabbix_proxy+DBName=/var/lib/zabbix/zabbix_proxy.db+' /etc/zabbix/zabbix_proxy.conf
sed -i 's/DBUser=zabbix/# DBUser=zabbix/' /etc/zabbix/zabbix_proxy.conf
sed -i 's/# ConfigFrequency=3600/ConfigFrequency=300/' /etc/zabbix/zabbix_proxy.conf


echo "[TASK 4] Setting firewall rules"
firewall-cmd --permanent --add-port=10051/tcp
firewall-cmd --reload

echo "[TASK 5] Enable and starting zabbix-agent service"; sleep 3
systemctl enable --now zabbix-proxy
systemctl restart zabbix-proxy


