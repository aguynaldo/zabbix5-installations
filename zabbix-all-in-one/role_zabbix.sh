#!/bin/bash

### Funçâo para ler as variaveis do arquivo .env
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}


### Definindo as CONSTANTES para configurar o banco de dados
ZABBIX_USER=$(read_var ZABBIX_USER /vagrant/.env)
ZABBIX_PASS=$(read_var ZABBIX_PASS /vagrant/.env)
ZABBIX_BD=$(read_var ZABBIX_BD /vagrant/.env)

echo "Mostrando as constantes"
echo $ZABBIX_BD
echo $ZABBIX_USER
echo $ZABBIX_PASS


echo "[TASK 1] Add oficial zabbix repo"; sleep 3
rpm -ivh http://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm

echo "[TASK 2] Clean cache and old repos"; sleep 3
dnf clean all

echo "[TASK 3] Installing zabbix-server"; sleep 3
dnf install -y zabbix-server

echo "[TASK 4] Loading initial database scheme "; sleep 3
zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -h localhost -u $ZABBIX_USER -p$ZABBIX_PASS $ZABBIX_BD

echo "[TASK 6]  Checking if database was populate"; sleep 3
mysql -h localhost -u $ZABBIX_USER -p$ZABBIX_PASS -e "show tables;" $ZABBIX_BD

echo "[TASK 7] Editing zabbix-server.conf"; sleep 3
cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf_original
sed -i 's/^DBName=zabbix/DBName='$ZABBIX_BD'/' /etc/zabbix/zabbix_server.conf
sed -i 's/^DBUser=zabbix/DBUser='$ZABBIX_USER'/' /etc/zabbix/zabbix_server.conf
sed -i 's/^# DBPassword=/DBPassword='$ZABBIX_PASS'/' /etc/zabbix/zabbix_server.conf

echo "[TASK 8] Enable and starting zabbix-server service"; sleep 3
systemctl enable --now zabbix-server

echo "[TASK 9] Checking zabbix-server state"; sleep 3
systemctl status zabbix-server

echo "[TASK 10] Checking logging of zabbix-server"; sleep 3
tail -n50 /var/log/zabbix/zabbix_server.log

echo "[TASK 11] Instaling zabbix-frontend with apache"; sleep 3
dnf -y install zabbix-web-mysql zabbix-apache-conf

echo "[TASK 12] Setting correct timezone for PHP"; sleep 3
#sed -i 's+Europe/Riga+America/Sao_Paulo+' /etc/php-fpm.d/zabbix.conf
#sed -i 's+; ++' /etc/php-fpm.d/zabbix.conf
cp /etc/php-fpm.d/zabbix.conf /etc/php-fpm.d/zabbix.conf_original
sed -i 's+; php_value\[date.timezone\] = Europe/Riga+php_value\[date.timezone\] = America/Sao_Paulo+' /etc/php-fpm.d/zabbix.conf

echo "[TASK 13] Enabling and Starting services (httpd and php-fpm)"; sleep 3
systemctl enable --now httpd php-fpm
systemctl status httpd php-fpm

echo "[TASK 14] Add firewall rules for http port"; sleep 3
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
