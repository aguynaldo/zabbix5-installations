#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### Setting the CONSTANT to set the root password (Operating system)
DH1_HOSTNAME=$(read_var DH1_HOSTNAME /vagrant/.env)
DH2_HOSTNAME=$(read_var DH2_HOSTNAME /vagrant/.env)
DH3_HOSTNAME=$(read_var DH3_HOSTNAME /vagrant/.env)
DH1_IP=$(read_var DH1_IP /vagrant/.env)
DH2_IP=$(read_var DH2_IP /vagrant/.env)
DH3_IP=$(read_var DH3_IP /vagrant/.env)

# echo "Root password"
# echo $ROOT_CENTOS

echo "[TASK 1] Generating ha-proxy.cfg"; sleep 3
echo "global
        log /dev/log    local0
        log /dev/log    local1 debug
        maxconn 2000
        chroot /var/lib/haproxy
        #stats socket /run/haproxy/admin.sock mode 660 level admin
        stats socket 0.0.0.0:14567
        stats timeout 30s
        user haproxy
        group haproxy
        daemon
        # Default SSL material locations
        #ca-base /etc/ssl/certs
        #crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        #ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
        #3ssl-default-bind-options no-sslv3
        #tune.ssl.default-dh-param 2048

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        maxconn 2000
        timeout connect 5000
        timeout client  6000000
        timeout server  6000000
        timeout http-request 6000000
        timeout http-keep-alive 6000000
        #errorfile 400 /etc/haproxy/errors/400.http
        #errorfile 403 /etc/haproxy/errors/403.http
        #errorfile 408 /etc/haproxy/errors/408.http
        #errorfile 500 /etc/haproxy/errors/500.http
        #errorfile 502 /etc/haproxy/errors/502.http
        #errorfile 503 /etc/haproxy/errors/503.http
        #errorfile 504 /etc/haproxy/errors/504.http
        balance  roundrobin
        stats enable
        stats uri     /admin?stats
        stats realm   Haproxy\ Statistics
        stats auth    admin:password

frontend traefik
        mode http
        bind 0.0.0.0:80
        option forwardfor
        monitor-uri /health
        default_backend backend_traefik

backend backend_traefik
        mode http
        cookie Zabbix prefix
        server $DH1_HOSTNAME $DH1_IP:80 cookie $DH1_HOSTNAME check
        server $DH2_HOSTNAME $DH2_IP:80 cookie $DH2_HOSTNAME check
        server $DH3_HOSTNAME $DH3_IP:80 cookie $DH3_HOSTNAME check
        stats admin  if TRUE
        option tcp-check

frontend zabbix_server
        mode tcp
        bind 0.0.0.0:10051
        default_backend backend_zabbix_server

backend backend_zabbix_server
        mode tcp
        server $DH1_HOSTNAME $DH1_IP:10051 check
        server $DH2_HOSTNAME $DH2_IP:10051 check
        server $DH3_HOSTNAME $DH3_IP:10051 check
        stats admin if TRUE
        option tcp-check

" > /etc/haproxy/haproxy.cfg