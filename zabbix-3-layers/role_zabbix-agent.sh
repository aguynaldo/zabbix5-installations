#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

ZABBIX_SRV_IP=$(read_var ZABBIX_SRV_IP /vagrant/.env)

echo "[TASK 1] Install Zabbix Agent."; sleep 3
dnf install -y zabbix-agent

echo "[TASK 2] Editing Zabbix Agent conf."; sleep 3
sed -i 's/^Server=127.0.0.1$/Server='$ZABBIX_SRV_IP'/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^ServerActive=127.0.0.1$/ServerActive='$ZABBIX_SRV_IP'/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Hostname=Zabbix server/# Hostname=Zabbix Server/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf

echo "[TASK 3] Enable and starting zabbix-agent service"; sleep 3
systemctl enable --now zabbix-agent
systemctl restart zabbix-agent

echo "[TASK 4] Setting firewall rules"
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

