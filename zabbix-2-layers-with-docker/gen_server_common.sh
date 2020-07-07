#!/bin/bash

### Function to read the constants of the .env file
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

### ### Setting IP for Swarm
SRV_DB_IP=$(read_var SRV_DB_IP /vagrant/.env)
ZABBIX_USER=$(read_var ZABBIX_USER /vagrant/.env)
ZABBIX_PASS=$(read_var ZABBIX_PASS /vagrant/.env)
ZABBIX_DB=$(read_var ZABBIX_DB /vagrant/.env)
MOUNT_POINT_NFS=$(read_var MOUNT_POINT_NFS /vagrant/.env)

echo "DB_SERVER_HOST=$SRV_DB_IP
DB_SERVER_PORT=3306
MYSQL_USER=$ZABBIX_USER
MYSQL_PASSWORD=$ZABBIX_PASS
MYSQL_DATABASE=$ZABBIX_DB
ZBX_TIMEOUT=30
ZBX_LISTENIP=
# Available since 3.4.0
#ZBX_HISTORYSTORAGEURL= 
# Available since 3.4.0
ZBX_HISTORYSTORAGETYPES=uint,dbl,str,log,text 
ZBX_STARTPOLLERS=10
ZBX_IPMIPOLLERS=0
# Available since 3.4.0
ZBX_STARTPREPROCESSORS=3 
ZBX_STARTPOLLERSUNREACHABLE=1
ZBX_STARTTRAPPERS=10
ZBX_STARTPINGERS=10
ZBX_STARTDISCOVERERS=1
ZBX_STARTHTTPPOLLERS=10
ZBX_STARTTIMERS=1
ZBX_STARTESCALATORS=1
# Available since 3.4.0
ZBX_STARTALERTERS=3 
ZBX_JAVAGATEWAY=zabbix-java-gateway
ZBX_JAVAGATEWAYPORT=10052
ZBX_STARTJAVAPOLLERS=5
# Available since 4.2.0
ZBX_STARTLLDPROCESSORS=2 
# Available since 4.0.5
ZBX_STATSALLOWEDIP= 
ZBX_STARTVMWARECOLLECTORS=1
ZBX_VMWAREFREQUENCY=60
ZBX_VMWAREPERFFREQUENCY=60
ZBX_VMWARECACHESIZE=64M
ZBX_VMWARETIMEOUT=10
ZBX_ENABLE_SNMP_TRAPS=false
ZBX_SOURCEIP=
ZBX_HOUSEKEEPINGFREQUENCY=1
ZBX_MAXHOUSEKEEPERDELETE=5000
ZBX_SENDERFREQUENCY=30
ZBX_CACHESIZE=64M
ZBX_CACHEUPDATEFREQUENCY=60
ZBX_STARTDBSYNCERS=4
# Available since 4.0.0
# ZBX_EXPORTFILESIZE=1G 
ZBX_HISTORYCACHESIZE=128M
ZBX_HISTORYINDEXCACHESIZE=64M
# Available since 4.0.0
ZBX_HISTORYSTORAGEDATEINDEX=0 
ZBX_TRENDCACHESIZE=64M
ZBX_VALUECACHESIZE=128M
ZBX_TRAPPERIMEOUT=300
ZBX_UNREACHABLEPERIOD=45
ZBX_UNAVAILABLEDELAY=60
ZBX_UNREACHABLEDELAY=15
ZBX_LOGSLOWQUERIES=3000
ZBX_STARTPROXYPOLLERS=1
ZBX_PROXYCONFIGFREQUENCY=3600
ZBX_PROXYDATAFREQUENCY=1
ZBX_TLSCAFILE=
ZBX_TLSCRLFILE=
ZBX_TLSCERTFILE=
ZBX_TLSKEYFILE=
" > $MOUNT_POINT_NFS/docker-files/envs/zabbix-server/common.env