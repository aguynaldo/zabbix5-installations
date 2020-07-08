#!/bin/bash

### Funçâo para ler as variaveis do arquivo .env
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}


### Definindo as CONSTANTES para configurar o banco de dados
ZABBIX_FRONTEND_USER=$(read_var ZABBIX_FRONTEND_USER /vagrant/.env)
ZABBIX_FRONTEND_PASS=$(read_var ZABBIX_FRONTEND_PASS /vagrant/.env)
ZABBIX_BD=$(read_var ZABBIX_BD /vagrant/.env)

echo "Mostrando as constantes"
echo $ZABBIX_BD
echo $ZABBIX_FRONTEND_USER
echo $ZABBIX_FRONTEND_PASS

echo "[TASK 01] Instaling zabbix-frontend with apache"; sleep 3
dnf -y install zabbix-web-mysql zabbix-apache-conf

echo "[TASK 22] Setting correct timezone for PHP"; sleep 3
cp /etc/php-fpm.d/zabbix.conf /etc/php-fpm.d/zabbix.conf_original
sed -i 's+; php_value\[date.timezone\] = Europe/Riga+php_value\[date.timezone\] = America/Sao_Paulo+' /etc/php-fpm.d/zabbix.conf

echo "[TASK 13] Enabling and Starting services (httpd and php-fpm)"; sleep 3
systemctl enable --now httpd php-fpm
systemctl status httpd php-fpm

echo "[TASK 14] Add firewall rules for http port"; sleep 3
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
