#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### ### Setting IP for Swarm
DNS_TRAEFIK=$(read_var DNS_TRAEFIK /vagrant/.env)
DNS_FRONTEND=$(read_var DNS_FRONTEND /vagrant/.env)
DNS_GRAFANA=$(read_var DNS_GRAFANA /vagrant/.env)
MOUNT_POINT_NFS=$(read_var MOUNT_POINT_NFS /vagrant/.env)


echo "vou salvar o $MOUNT_POINT_NFS/docker-files/docker-compose.yaml"

echo "version: \"3.7\"

x-deploy: &template-deploy
  replicas: 1
  restart_policy:
    condition: on-failure
  update_config:
    parallelism: 1
    delay: 10s

services:
  traefik:
    image: traefik:v2.2.1
    deploy:
      mode: global
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 1
        delay: 10s
      placement:
        constraints:
          - node.role == manager
      labels:
        - \"traefik.enable=true\"
        - \"traefik.http.routers.traefik.rule=Host(\`$DNS_TRAEFIK\`)\"
        - \"traefik.http.services.justAdummyService.loadbalancer.server.port=1337\"
        - \"traefik.http.routers.traefik.service=api@internal\"
    ports:
      - \"80:80\"
      - \"843:443\"
    networks:
      - \"monitoring-network\"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    command:
      - \"--api=true\"
      - \"--log.level=DEBUG\"
      - \"--providers.docker.endpoint=unix:///var/run/docker.sock\"
      - \"--providers.docker.swarmMode=true\"
      - \"--providers.file.directory=/etc/traefik/dynamic\"
      - \"--providers.docker.exposedbydefault=false\"
      - \"--entrypoints.web.address=:80\"
  zabbix-server:
    image: zabbix/zabbix-server-mysql:centos-5.0-latest
    env_file: 
      - ./envs/zabbix-server/common.env
    networks:
      - \"monitoring-network\"
    volumes:
        - $MOUNT_POINT_NFS/zabbix-server/externalscripts:/usr/lib/zabbix/externalscripts:ro
        - $MOUNT_POINT_NFS/zabbix-server/alertscripts:/usr/lib/zabbix/alertscripts:ro
    ports:
      - \"10051:10051\"
    deploy:
      <<: *template-deploy
      labels:
        - \"traefik.enable=false\"
  zabbix-frontend:
    image: zabbix/zabbix-web-nginx-mysql:alpine-5.0.1
    env_file: 
      - ./envs/zabbix-frontend/common.env
    networks:
      - \"monitoring-network\"
    deploy: 
      <<: *template-deploy
      labels:
        - \"traefik.enable=true\"
        - \"traefik.http.routers.zbx-frontend.entrypoints=web\"
        - \"traefik.http.routers.zbx-frontend.rule=Host(\`$DNS_FRONTEND\`)\"
        - \"traefik.http.services.zbx-frontend.loadbalancer.server.port=8080\"
  grafana:
    image: grafana/grafana:7.0.3
    environment: 
      - GF_INSTALL_PLUGINS=alexanderzobnin-zabbix-app
    volumes:
      - $MOUNT_POINT_NFS/grafana/data:/var/lib/grafana
    networks:
      - \"monitoring-network\"
    deploy: 
      <<: *template-deploy
      labels:
        - \"traefik.enable=true\"
        - \"traefik.http.routers.grafana.entrypoints=web\"
        - \"traefik.http.routers.grafana.rule=Host(\`$DNS_GRAFANA\`)\"
        - \"traefik.http.services.grafana.loadbalancer.server.port=3000\"

networks: 
  monitoring-network:
    external: true
" > $MOUNT_POINT_NFS/docker-files/docker-compose.yaml