# zabbix5-installations

Multiple way to install zabbix 5 in Virtualbox VMs

| Folders | Installation type |  Status |
| - | - | - |
| [zabbix-all-in-one](zabbix-all-in-one/README.md) | Install mysql-server and zabbix-server and zabbix-frontend in only one server running CentOS-8.2. | Done |
| [zabbix-2-layers-with-docker](zabbix-2-layers-with-docker/README.md) | Create 2 VMs. One host with mysql-server and other with docker-ce. On docker swarm there are 3 services: zabbix-server, zabbix-frontend and grafana.| Doing |
| zabbix-3-layers | - | To do |
| zabbix-cluster-swarm | - | To do |

## Requirements

* [Vagrant](https://www.vagrantup.com/)
* [Vagrant plugin vagrant-env](https://github.com/gosuri/vagrant-env)
* [Virtualbox 6.0+](https://www.virtualbox.org/)

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
