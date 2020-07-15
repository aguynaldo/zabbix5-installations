#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

PROXY01_SRV_IP=$(read_var PROXY01_SRV_IP /vagrant/.env)
ZABBIX_HOSTNAME=$(read_var ZABBIX_HOSTNAME /vagrant/.env)
PROXY01_HOSTNAME=$(read_var PROXY01_HOSTNAME /vagrant/.env)

host_name=$(hostname)

echo "[TASK 1] Install Zabbix Agent."; sleep 3
dnf install -y zabbix-agent

echo "[TASK 2] Editing Zabbix Agent conf."; sleep 3
# Mantem o ip de loopback para os zabbix-server e zabbix-proxy.
if [ $host_name != $ZABBIX_HOSTNAME ] && [ $host_name != $PROXY01_HOSTNAME ]; then
    sed -i 's/^Server=127.0.0.1$/Server='$PROXY01_SRV_IP'/' /etc/zabbix/zabbix_agentd.conf
    sed -i 's/^ServerActive=127.0.0.1$/ServerActive='$PROXY01_SRV_IP'/' /etc/zabbix/zabbix_agentd.conf
fi
sed -i 's/Hostname=Zabbix server/# Hostname=Zabbix Server/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf

echo "[TASK 3] Enable and starting zabbix-agent service"; sleep 3
systemctl enable --now zabbix-agent
systemctl restart zabbix-agent

echo "[TASK 4] Setting firewall rules"
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

