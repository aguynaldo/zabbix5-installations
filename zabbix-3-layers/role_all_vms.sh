#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### Setting the CONSTANT to set the root password (Operating system)
ROOT_CENTOS=$(read_var ROOT_CENTOS /vagrant/.env)
UTILS_4ALL_VMS=$(read_var UTILS_4ALL_VMS /vagrant/.env)

# Setting correct timezone
echo "[TASK 1] Set correct timezone America/Sao_Paulo"; sleep 3
timedatectl set-timezone $(timedatectl list-timezones | grep Sao_Paulo)
timedatectl

# Install basics utilities ()
echo "[TASK 2] Install utils programs"; sleep 3
dnf clean all
dnf check-update
dnf install -y $UTILS_4ALL_VMS

# Setting root password
echo "[TASK 3] Set root password"; sleep 3
echo -e "$ROOT_CENTOS\n$ROOT_CENTOS" | passwd root

# Enabling firewalld service on boot
echo "[TASK 4] Enable firewalld"; sleep 3
systemctl enable --now firewalld
firewall-cmd --reload

# It's necessary to install zabbix-agent in all server.
echo "[TASK 5] Add oficial zabbix repo"; sleep 3
rpm -ivh http://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm

echo "[TASK 6] Clean cache and old repos"; sleep 3
dnf clean all