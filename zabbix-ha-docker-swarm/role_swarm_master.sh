echo "\n\n\n\n\n"
echo "[TASK 8] Enabling swarm"; sleep 3
docker swarm init --advertise-addr $ZABBIX_SRV_IP

echo "\n\n\n\n\n"
echo "[TASK 9] Add network for monitoring environment "; sleep 3
docker network create --driver overlay monitoring-network

echo "\n\n\n\n\n"
echo "[TASK 10] Inspect of all docker networks"; sleep 3
for net in `docker network ls |grep -v NAME | awk '{print $2}'`;do ipam=`docker network inspect $net --format {{.IPAM}}` && echo $net - $ipam; done

echo "\n\n\n\n\n"
echo "[TASK 11] Add permission on firewall to port 10050 needed to zabbix."; sleep 3
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

echo "\n\n\n\n\n"
echo "[TASK 12] Create folders for grafana"; sleep 3
mkdir -p /mnt/data-docker/grafana/data && \
chown -R 472:472 /mnt/data-docker/grafana/data && \
chmod -R 775 /mnt/data-docker/grafana && mkdir -p /mnt/data-docker/grafana/certs && \
chown -R 472:472 /mnt/data-docker/grafana/certs


echo "\n\n\n\n\n"
echo "[TASK 13] Generating the frontend common.env file"; sleep 3
cd /vagrant
bash gen_frontend_common.sh

echo "\n\n\n\n\n"
echo "[TASK 14]Generating the server common.env file"; sleep 3
bash gen_server_common.sh

echo "\n\n\n\n\n"
echo "[TASK 15] Starting stack on swarm"; sleep 3
cd /vagrant/maratonazabbix
docker stack deploy -c docker-compose.yaml maratonazabbix
