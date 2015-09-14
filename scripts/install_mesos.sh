#!/bin/bash

function init () {
  apt-get update
}

function install_jdk () {
  apt-get install -y openjdk-7-jdk
}

function install_mesos () {
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

  echo "deb http://repos.mesosphere.com/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list

  apt-get update

  apt-get -y install mesos marathon
}

init
install_jdk
install_mesos

exit 0
