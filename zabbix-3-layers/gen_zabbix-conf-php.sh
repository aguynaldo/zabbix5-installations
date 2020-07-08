#!/bin/bash

### Funçâo para ler as variaveis do arquivo .env
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}


### Definindo as CONSTANTES para configurar o banco de dados
ZABBIX_FRONTEND_USER=$(read_var ZABBIX_FRONTEND_USER /vagrant/.env)
ZABBIX_FRONTEND_PASS=$(read_var ZABBIX_FRONTEND_PASS /vagrant/.env)
ZABBIX_DB=$(read_var ZABBIX_DB /vagrant/.env)
SRV_DB_IP=$(read_var SRV_DB_IP /vagrant/.env)
ZABBIX_SRV_IP=$(read_var ZABBIX_SRV_IP /vagrant/.env)
ZBX_SERVER_NAME=$(read_var ZBX_SERVER_NAME /vagrant/.env)

echo "Mostrando as constantes"
echo $ZABBIX_DB
echo $ZABBIX_FRONTEND_USER
echo $ZABBIX_FRONTEND_PASS
echo $SRV_DB_IP
echo $ZABBIX_SRV_IP
echo $ZBX_SERVER_NAME

echo "<?php
// Zabbix GUI configuration file.

\$DB['TYPE']                     = 'MYSQL';
\$DB['SERVER']                   = '$SRV_DB_IP';
\$DB['PORT']                     = '0';
\$DB['DATABASE']                 = '$ZABBIX_DB';
\$DB['USER']                     = '$ZABBIX_FRONTEND_USER';
\$DB['PASSWORD']                 = '$ZABBIX_FRONTEND_PASS';

// Schema name. Used for PostgreSQL.
\$DB['SCHEMA']                   = '';

// Used for TLS connection.
\$DB['ENCRYPTION']               = false;
\$DB['KEY_FILE']                 = '';
\$DB['CERT_FILE']                = '';
\$DB['CA_FILE']                  = '';
\$DB['VERIFY_HOST']              = false;
\$DB['CIPHER_LIST']              = '';

// Use IEEE754 compatible value range for 64-bit Numeric (float) history values.
// This option is enabled by default for new Zabbix installations.
// For upgraded installations, please read database upgrade notes before enabling this option.
\$DB['DOUBLE_IEEE754']   = true;

\$ZBX_SERVER                     = '$ZABBIX_SRV_IP';
\$ZBX_SERVER_PORT                = '10051';
\$ZBX_SERVER_NAME                = '$ZBX_SERVER_NAME';

\$IMAGE_FORMAT_DEFAULT   = IMAGE_FORMAT_PNG;

// Uncomment this block only if you are using Elasticsearch.
// Elasticsearch url (can be string if same url is used for all types).
//\$HISTORY['url'] = [
//      'uint' => 'http://localhost:9200',
//      'text' => 'http://localhost:9200'
//];
// Value types stored in Elasticsearch.
//\$HISTORY['types'] = ['uint', 'text'];

// Used for SAML authentication.
// Uncomment to override the default paths to SP private key, SP and IdP X.509 certificates, and to set extra settings.
//\$SSO['SP_KEY']                        = 'conf/certs/sp.key';
//\$SSO['SP_CERT']                       = 'conf/certs/sp.crt';
//\$SSO['IDP_CERT']              = 'conf/certs/idp.crt';
//\$SSO['SETTINGS']              = [];
" > /etc/zabbix/web/zabbix.conf.php