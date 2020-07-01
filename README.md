# zabbix5-installations

Multiple way to install zabbix 5 in Virtualbox VMs

| Folders | Installation type |  
| - | - |
| zabbix-all-in-one | Install mysql-server and zabbix-server and zabbix-frontend in only one server running CentOS-8.2. |
| zabbix-three-layer | Install in different server mysql-server (one) and zabbix-server (one) and zabbix-frontend (other), all running CentOS-8.2 |
| zabbix-all-in-one-docker | Install in different server mysql-server on CentOS and zabbix-server, zabbix-frontend and grafana in Docker Swarm stack. in only one server running CentOS-8.2. | 

## Requirements

* vagrant 
* vagrant plugin vagrant-env (vagrant plugin install vagrant-env)
* virtualbox 6.0+

### My environment

These files were tested in 2 machines. 

#### Debian 10

| Softwares | Versions |  
| - | - |
| Debian | 10 (buster) - 64 bits |  
| Vagrant |Vagrant 2.2.9 |  
| Plugin vagrant-env | vagrant-env (0.0.3, global) |  
| Virtualbox | Versão 6.1.10 r138449 (Qt5.11.3) |

#### Ubuntu 20.04

| Softwares | Versions |  
| - | - |
| Ubuntu | 20.04 LTS (Focal Fossa) |  
| Vagrant | Vagrant 2.2.9 |  
| Plugin vagrant-env | vagrant-env (0.0.3, global) |  
| Virtualbox | Versão 6.1.10 r138449 (Qt5.11.3) |

## Attention

If some error occurring during the execution scripts you need destroy the VMs and execute the command "vagrant up" again.

This scripts aren't prepared to treat exceptions yet.
