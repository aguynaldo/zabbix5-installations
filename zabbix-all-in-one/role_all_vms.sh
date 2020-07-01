#!/bin/bash

### Funçâo para ler as variaveis do arquivo .env
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### Definindo as CONSTANTES para configurar o banco de dados
ROOT_CENTOS=$(read_var ROOT_CENTOS /vagrant/.env)

echo "SEnha do root"
echo $ROOT_CENTOS

# Update hosts file
echo "[TASK 1] Set correct timezone"; sleep 3
timedatectl set-timezone $(timedatectl list-timezones | grep Sao_Paulo)
timedatectl


echo "[TASK 2] Install utils programs"; sleep 3
dnf clean all
dnf check-update
dnf install -y net-tools vim nano epel-release wget curl tcpdump git


echo "[TASK 3] Set root password"; sleep 3
echo -e "$ROOT_CENTOS\n$ROOT_CENTOS" | passwd root


echo "[TASK 4] Enable firewalld"; sleep 3
systemctl enable --now firewalld
firewall-cmd --reload
