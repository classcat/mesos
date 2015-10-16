#!/bin/bash

########################################################################
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
########################################################################

# --- PREREQUISITE -----------------------------------------------------
# JDK required.
#
# --- HISTORY ----------------------------------------------------------
# 16-oct-15 : add jdk.
# 15-oct-15 : remove jdk
# ----------------------------------------------------------------------


export LC_ALL=C

. ../conf/mesos_slave.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to install mesos slave node. Continue ? (y/n) : " >&2

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


function install_mesos_slave () {
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

  echo "deb http://repos.mesosphere.com/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list

  apt-get update

  apt-get -y install mesos
}


function config_mesos () {
  echo "zk://${ZOOKEEPER_IP}:2181/mesos" > /etc/mesos/zk
}


function restart_mesos_slave () {
  service mesos-slave restart
}


function disable_zookeeper () {
  service zookeeper stop
  sh -c "echo manual > /etc/init/zookeeper.override"
}


function disable_mesos_master () {
  service mesos-master stop
  sh -c "echo manual > /etc/init/mesos-master.override"
}


function finalize () {
  echo ""
  echo "completed."
  echo ""
}



###################
### ENTRY_POINT ###
###################

init

install_jdk

install_mesos_slave

config_mesos

disable_zookeeper

disable_mesos_master

restart_mesos_slave

finalize

exit 0


### End of Script ###
