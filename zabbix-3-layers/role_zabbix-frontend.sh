#!/bin/bash

echo "[TASK 01] Instaling zabbix-frontend with apache"; sleep 3
dnf -y install zabbix-web-mysql zabbix-apache-conf

echo "[TASK 02] Setting correct timezone for PHP"; sleep 3
cp /etc/php-fpm.d/zabbix.conf /etc/php-fpm.d/zabbix.conf_original
sed -i 's+; php_value\[date.timezone\] = Europe/Riga+php_value\[date.timezone\] = America/Sao_Paulo+g' /etc/php-fpm.d/zabbix.conf

echo "[TASK 03] Enabling and Starting services (httpd and php-fpm)"; sleep 3
systemctl enable --now httpd php-fpm
systemctl status httpd php-fpm

echo "[TASK 04] Add firewall rules for http port"; sleep 3
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload


echo "[TASK 05] Generating zabbix.conf.php file"; sleep 3
cd /vagrant
bash gen_zabbix-conf-php.sh