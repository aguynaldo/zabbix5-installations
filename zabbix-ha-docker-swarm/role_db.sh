#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### Defining the CONSTANTS to set the database
MYSQL_ROOT_PASSWORD=$(read_var MYSQL_ROOT_PASSWORD /vagrant/.env)
ZABBIX_USER=$(read_var ZABBIX_USER /vagrant/.env)
ZABBIX_PASS=$(read_var ZABBIX_PASS /vagrant/.env)
ZABBIX_DB=$(read_var ZABBIX_DB /vagrant/.env)
DH1_IP=$(read_var DH1_IP /vagrant/.env)
DH2_IP=$(read_var DH2_IP /vagrant/.env)
DH3_IP=$(read_var DH3_IP /vagrant/.env)


# Disabling SELinux
echo "\n\n\n\n\n"
echo "[TASK 1] Desabling SELinux"; sleep 3
sestatus
sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config
setenforce 0
sestatus

# Install MySQL 8
echo "\n\n\n\n\n"
echo "[TASK 2] Install MySQL 8."; sleep 3
dnf install -y mysql-server

# Enabling mysql-server on boot and starting it now.
echo "\n\n\n\n\n"
echo "[TASK 3] Enabling mysql-server on boot and starting it now"; sleep 3
systemctl enable --now mysqld

# Executing the mysql_secure_installation to define mysql initial settings 
echo "\n\n\n\n\n"
echo "[TASK 4] MySQL secure Instalation do MySQL 8"; sleep 3
echo "[TASK 4.1] Installing the expect"
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

echo "\n\n\n\n\n"
echo "[TASK 4.2] Starting o expect do mysql_secure_installation"; sleep 3
echo "$SECURE_MYSQL"

echo "Remove expect"; sleep 3
dnf remove -y expect

echo "\n\n\n\n\n"
echo "[TASK 5] Creating user and database for Zabbix"; sleep 3
SQL1="create database ${ZABBIX_DB} character set utf8 collate utf8_bin;"
SQL2="CREATE USER '${ZABBIX_USER}'@'localhost' IDENTIFIED BY '${ZABBIX_PASS}';"
SQL3="grant all privileges on ${ZABBIX_DB}.* to '${ZABBIX_USER}'@'localhost';"
SQL4="create user '${ZABBIX_USER}'@'${DH1_IP}' identified with mysql_native_password by '${ZABBIX_PASS}';"
SQL5="grant all privileges on ${ZABBIX_DB}.* to '${ZABBIX_USER}'@'${DH1_IP}';"
SQL6="UPDATE mysql.user SET Super_Priv='Y' WHERE user='${ZABBIX_USER}' AND host='${DH1_IP}';"
SQL7="create user '${ZABBIX_USER}'@'${DH2_IP}' identified with mysql_native_password by '${ZABBIX_PASS}';"
SQL8="grant all privileges on ${ZABBIX_DB}.* to '${ZABBIX_USER}'@'${DH2_IP}';"
SQL9="UPDATE mysql.user SET Super_Priv='Y' WHERE user='${ZABBIX_USER}' AND host='${DH2_IP}';"
SQL10="create user '${ZABBIX_USER}'@'${DH3_IP}' identified with mysql_native_password by '${ZABBIX_PASS}';"
SQL11="grant all privileges on ${ZABBIX_DB}.* to '${ZABBIX_USER}'@'${DH3_IP}';"
SQL12="UPDATE mysql.user SET Super_Priv='Y' WHERE user='${ZABBIX_USER}' AND host='${DH3_IP}';"
SQL13="flush privileges;"
mysql -h localhost -u root -p${MYSQL_ROOT_PASSWORD} -e "${SQL1}${SQL2}${SQL3}${SQL4}${SQL5}${SQL6}${SQL7}${SQL8}${SQL9}${SQL10}${SQL11}${SQL12}${SQL13}"


echo "\n\n\n\n\n"
echo "[TASK 6] Adding permissions for mysql on the Firewall"; sleep 3
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload
