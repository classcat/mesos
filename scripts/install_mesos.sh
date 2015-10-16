#!/bin/bash

###############################################################
# ClassCat(R) Analytics Platform for Spark
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
###############################################################

# --- PREREQUISITE -----------------------------------------------------
# JDK required.
#
#--- HISTORY --------------------------------------------------
# 16-oct-16 : finally, add jdk here.
# 15-oct-15 : remove jdk.
# 19-sep-15 : remove marathon.
#--------------------------------------------------------------

export LC_ALL=C

. ../conf/mesos.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to install mesos master node. Continue ? (y/n) : " >&2

  read var_continue
  if [ -z "$var_continue" ] || [ "$var_continue" != 'y' ]; then
    echo -e "Exit the install program."
    echo -e ""
    exit 1
  fi
}


function init () {
  check_if_continue

  apt-get update
}


function install_jdk () {
  apt-get install -y openjdk-7-jdk
}


function install_mesos () {
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

  echo "deb http://repos.mesosphere.com/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list

  apt-get update

  # 19-sep-15 : marathon removed
  apt-get -y install mesos
  #apt-get -y install mesos marathon
}


function config_zookeeper () {
  local ZOO_CONF_MYID=/etc/zookeeper/conf/myid
  local ZOO_CONF_CFG=/etc/zookeeper/conf/zoo.cfg

  echo "1" > ${ZOO_CONF_MYID}

  mv ${ZOO_CONF_CFG} "${ZOO_CONF_CFG}.bak"

  cat << _EOT_ > ${ZOO_CONF_CFG}
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/var/lib/zookeeper
clientPort=2181
_EOT_

  echo "server.1=${ZOOKEEPER_IP}:2888:3888" >> ${ZOO_CONF_CFG}
}


function config_mesos () {
  echo "zk://${ZOOKEEPER_IP}:2181/mesos" > /etc/mesos/zk
}


function config_mesos_master () {
  echo "1" > /etc/mesos-master/quorum
}


function restart_zookeeper () {
  service zookeeper restart
}


function restart_mesos_master () {
  service mesos-master restart
}


#function restart_marathon () {
#  service marathon restart
#}


function restart_mesos_slave () {
  service mesos-slave restart
}


function disable_mesos_slave () {
  service mesos-slave stop
  sh -c "echo manual > /etc/init/mesos-slave.override"
}


function finalize () {
  echo ""
  echo "completed."
  echo "Check the following URL : "
  echo "\thttp://${ZOOKEEPER_IP}:5050"
  echo ""
}



###################
### ENTRY_POINT ###
###################

init

install_jdk

install_mesos

config_zookeeper

config_mesos

config_mesos_master

restart_zookeeper

restart_mesos_master

#restart_marathon

if [ $SLAVE_INSTALL == "true" ]; then
  restart_mesos_slave
else
  disable_mesos_slave
fi

finalize

exit 0


### End of Script ###
