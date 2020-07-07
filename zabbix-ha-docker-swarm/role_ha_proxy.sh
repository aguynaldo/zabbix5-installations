#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

ROOT_CENTOS=$(read_var ROOT_CENTOS /vagrant/.env)
UTILS_4ALL_VMS=$(read_var UTILS_4ALL_VMS /vagrant/.env)

# echo "Root password"
# echo $ROOT_CENTOS

echo "[TASK 1] Install tools for compile ha-proxy"; sleep 3
dnf install -y gcc pcre-devel tar make 

echo "[TASK 2] Downloading haproxy 2"; sleep 3
cd /tmp
wget http://www.haproxy.org/download/2.0/src/haproxy-2.0.14.tar.gz -O haproxy.tar.gz

echo "[TASK 3] Compiling haproxy 2"; sleep 3
tar xzvf haproxy.tar.gz -C /tmp
cd haproxy-2.0.14/
make TARGET=linux-glibc
make install

#Configurações finais
echo "[TASK 4] Setting haproxy 2"; sleep 3
mkdir -p /etc/haproxy
mkdir -p /var/lib/haproxy 
touch /var/lib/haproxy/stats
ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy
cp /tmp/haproxy-2.0.14/examples/haproxy.init /etc/init.d/haproxy
chmod 755 /etc/init.d/haproxy
systemctl daemon-reload
chkconfig haproxy on
useradd -r haproxy

echo "[TASK 6] Printing haproxy version"; sleep 3
haproxy -v

echo "[TASK 7] Creating haproxy.cfg file"; sleep 3
bash /vagrant/gen_haproxy.sh

echo "[TASK 8] Setting firewall"; sleep 3
#Criar regras de firewall
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=10051/tcp
firewall-cmd --reload

#Configurar iniciar o serviço
echo "[TASK 9] Starting haproxy now"; sleep 3
systemctl start haproxy
systemctl status haproxy