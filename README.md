# Mesos Cluster

## Security Group

* Private 側は Master <=> Slave を通す。
* 複数の Master の時にどうするか。

### Master

* 22   : ssh
* 2181 : zookeeper
* 5050 : mesos-master
* (5051 : mesos-slave)
* ((8080 : marathon))
* 8080 : zeppelin

### Slave

* 22   : ssh
* 5051 : mesos-slave

  
## インストール準備

### 設定

\* ec2 では不要

* /etc/hosts
* /etc/hostname
* hotname --fqdn

### 更新

* \# apt-get update
* \# apt-get upgrade
* \# apt-get dist-upgrade

* \# sync & reboot

* (\# apt-get install git)
