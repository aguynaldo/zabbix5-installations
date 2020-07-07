#!/bin/bash


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

##### REMOVER ESSE LINHA OU COMENTÁ-LA SE DESEJAR QUE SOMENTE O root EXECUTE COMANDOS DOCKER
usermod -aG docker vagrant

echo "[TASK 6] Enabling routing masquerade between containers"; sleep 3
firewall-cmd --zone=public --add-masquerade --permanent
firewall-cmd --reload

echo "[TASK 7] Setting firewall allowing ports for cluster swarm."; sleep 3
firewall-cmd --permanent --add-port=2377/tcp
firewall-cmd --permanent --add-port=7946/tcp
firewall-cmd --permanent --add-port=7946/udp
firewall-cmd --permanent --add-port=4789/udp
firewall-cmd --reload

echo "[TASK 8] Verify docker version"; sleep 3
docker version



