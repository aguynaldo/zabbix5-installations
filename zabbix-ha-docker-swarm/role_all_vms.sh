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

# echo "Root password"
# echo $ROOT_CENTOS

# Setting correct timezone
echo "\n\n\n\n\n"
echo "[TASK 1] Set correct timezone America/Sao_Paulo"; sleep 3
timedatectl set-timezone $(timedatectl list-timezones | grep Sao_Paulo)
timedatectl

# Install basics utilities ()
echo "\n\n\n\n\n"
echo "[TASK 2] Install utils programs"; sleep 3
dnf clean all
dnf check-update
dnf install -y $UTILS_4ALL_VMS

# Setting root password
echo "\n\n\n\n\n"
echo "[TASK 3] Set root password"; sleep 3
echo -e "$ROOT_CENTOS\n$ROOT_CENTOS" | passwd root

# Enabling firewalld service on boot
echo "\n\n\n\n\n"
echo "[TASK 4] Enable firewalld"; sleep 3
systemctl enable --now firewalld
firewall-cmd --reload
