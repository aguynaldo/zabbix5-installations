#!/bin/bash

### Funçâo para ler as variaveis do arquivo .env
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### Definindo as CONSTANTES para configurar o banco de dados
MYSQL_ROOT_PASSWORD=$(read_var MYSQL_ROOT_PASSWORD /vagrant/.env)
ZABBIX_USER=$(read_var ZABBIX_USER /vagrant/.env)
ZABBIX_PASS=$(read_var ZABBIX_PASS /vagrant/.env)
ZABBIX_BD=$(read_var ZABBIX_BD /vagrant/.env)


# Update hosts file
echo "[TASK 1] Desabling SELinux"; sleep 3
sestatus
sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config
setenforce 0
sestatus

echo "[TASK 2] Instalando o MySQL 8"; sleep 3
dnf install -y mysql-server

echo "[TASK 3] Habilitando e iniciando o MySQL 8"; sleep 3
systemctl enable --now mysqld

echo "[TASK 4] MySQL secure Instalation do MySQL 8"; sleep 3
echo "Instalando o expect"
dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/expect-5.45.4-5.el8.x86_64.rpm

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Press y|Y for Yes, any other key for No: \"
send \"y\r\"
expect \"Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: \"
send \"1\r\"
expect \"New password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No):\"
send \"y\r\"
expect \"Remove anonymous users? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect eof
")

echo "[TASK 4.1] Iniciando o expect do mysql_secure_installation"; sleep 3
echo "$SECURE_MYSQL"

echo "Remove expect????"; sleep 3
#dnf remove -y expect

echo "[TASK 5] Criando o banco de dados para Zabbix"; sleep 3
SQL1="create database ${ZABBIX_BD} character set utf8 collate utf8_bin;"
SQL2="CREATE USER '${ZABBIX_USER}'@'localhost' IDENTIFIED BY '${ZABBIX_PASS}';"
SQL3="grant all privileges on ${ZABBIX_BD}.* to '${ZABBIX_USER}'@'localhost';"
SQL4="flush privileges;"
mysql -h localhost -u root -p${MYSQL_ROOT_PASSWORD} -e "${SQL1}${SQL2}${SQL3}${SQL4}"


echo "[TASK 6] Adicionando permissões no Firewall"; sleep 3
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload
