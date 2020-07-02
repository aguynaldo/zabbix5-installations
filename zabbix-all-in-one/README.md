# Instructions

There are 2 ways to execute these scripts.

## Using Vagrant

These scripts will to install mysql-server, zabbix-server, zabbix-frontend all in only one server.

1. Clone this repository

    ```bash  
    git clone https://github.com/aguynaldo/zabbix5-installations.git
    ```

2. Enter the "zabbix5-installations/zabbix-all-in-one" directory

   ```bash  
    cd zabbix5-installations/zabbix-all-in-one
    ```

3. **Edit env_renomear file with variables of your environment.**
    | CONSTANT | VALUES  |
    |---|---|
    | ROOT_CENTOS | Root's password   |
    | BOX_NAME | bento/centos-8.2 |
    | INTERFACE_BRIDGE_HOST_FISICO | Interface to set bridge network mode   |
    | SRV_HOSTNAME | The hostname of VM  |
    | SRV_CPU | Amount of CPU   |
    | SRV_RAM | Amount of Memory |
    | SRV_IP  | IP address of VM  |
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
3. role_zabbix.sh

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
