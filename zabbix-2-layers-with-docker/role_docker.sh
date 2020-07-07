#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### ### Setting IP for Swarm
DOCKER_SRV_IP=$(read_var DOCKER_SRV_IP /vagrant/.env)

echo $DOCKER_SRV_IP


echo "[TASK 1] Adding Docker repo"; sleep 3
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

echo "[TASK 2] Removing old repos"; sleep 3
dnf clean all

echo "[TASK 3] Installing Device Mapper"; sleep 3
dnf install -y device-mapper-persistent-data

echo "[TASK 4]  Installing Docker-ce"; sleep 3
dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install -y docker-ce

echo "[TASK 5] Enabling the docker daemon on boot and execute it now"; sleep 3
systemctl enable --now docker
systemctl status docker

echo "[TASK 6] Enabling routing masquerade between containers"; sleep 3
firewall-cmd --zone=public --add-masquerade --permanent
firewall-cmd --reload

echo "[TASK 7] Verify docker version"; sleep 3
docker version

echo "[TASK 8] Enabling swarm"; sleep 3
docker swarm init --advertise-addr $DOCKER_SRV_IP

echo "[TASK 9] Add network for monitoring environment "; sleep 3
docker network create --driver overlay monitoring-network

echo "[TASK 10] Inspect of all docker networks"; sleep 3
for net in `docker network ls |grep -v NAME | awk '{print $2}'`;do ipam=`docker network inspect $net --format {{.IPAM}}` && echo $net - $ipam; done

echo "[TASK 11] Add permission on firewall to port 10050 needed to zabbix."; sleep 3
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

##### REMOVER ESSE LINHA OU COMENTÁ-LA se quiser que somente o root execute o docker
echo "[TASK 12] Add vagrant user to docker group permissions"; sleep 3
usermod -aG docker vagrant