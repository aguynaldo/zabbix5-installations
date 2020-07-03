# Environment with 2 servers

These scripts will create 2 VMs. In one of them, you will install mysql-server
and in the other, docker-ce.

Zabbix-server, zabbix-frontend and grafana will be three containers in Docker.

It will install CentOS 8.2 images on both servers.

## Instructions

There are 2 ways to execute these scripts.

## Using Vagrant

1. Clone this repository

    ```bash  
    git clone https://github.com/aguynaldo/zabbix5-installations.git
    ```

2. Enter the "zabbix5-installations/zabbix-2-layers-with-docker" directory

   ```bash  
    cd zabbix5-installations//zabbix-2-layers-with-docker
    ```

3. **Edit env_renomear file with variables of your environment.**
    | CONSTANT | VALUES  |
    |---|---|
    | ROOT_CENTOS | Root's password   |
    | BOX_NAME | bento/centos-8.2 |
    | INTERFACE_BRIDGE_HOST_FISICO | Interface to set bridge network mode   |
    | MYSQL_HOSTNAME | The hostname of VM mysql-server  |
    | MYSQL_CPU | Amount of CPU   |
    | MYSQL_RAM | Amount of Memory |
    | SRV_BD_IP | IP address of VM mysql-server |
    | ZBX_HOSTNAME | The hostname of VM zabbix-server |
    | ZBX_CPU | Amount of CPU |
    | ZBX_RAM | Amount of Memory |
    | ZABBIX_SRV_IP | IP address of VM docker server|
    | MYSQL_ROOT_PASSWORD | The mysql root user password  |
    | ZABBIX_USER | User to zabbix connect to mysql   |
    | ZABBIX_PASS | Password to zabbix mysql user  |
    | ZABBIX_BD | Database of Zabbix   |

4. Rename it env_renomear to .env.

    ```bash  
    cp env_renomear .env
    ```

5. Execute vagrant

    ```bash  
    vagrant up
    ```

6. Open the browser and type http://YOUR_IP/zabbix

**ATTENTION**  
If some error occurring during the execution scripts you need destroy the VMs and execute the command "vagrant up" again.

This scripts aren't prepared to treat exceptions yet.

```bash
vagrant destroy -f && rm -rf .vagrant && sleep 3 && vagrant up
```

## Using only .sh scripts

If you don't want to use vagrant, you can copy all the .sh scripts and the .env file to one VM with CentOS 8+ and run them in that order:

1. role_all_vms.sh
2. role_bd.sh
3. role_docker_zbx.sh

**ATTENTION**  
You still need the .env file in the same directory as the .sh scripts.

It's mandatory you edit all .sh scripts and change the path to env file if you will execute only the .sh scripts.

Bellow an example.

```bash
### Setting the CONSTANTS using Vagrant (path to env file)
ROOT_CENTOS=$(read_var ROOT_CENTOS /vagrant/.env)
```

```bash
### Setting the CONSTANTS only .sh scripts (path to env file)
ROOT_CENTOS=$(read_var ROOT_CENTOS .env)
```

**It is also necessary to edit  gen_server_common.sh and gen_frontend_common.sh files.**

Change the path on the last line of in both files (remove "/vagrant/") :

```NOTE
> /vagrant/maratonazabbix/envs/zabbix-server/common.env
```

for:

```bash
> maratonazabbix/envs/zabbix-server/common.env
```
