#!/bin/bash

###############################################################
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
###############################################################

#--- HISTORY ----------------------------------------------------------
#----------------------------------------------------------------------


export LC_ALL=C

CWD=`pwd`

mkdir -p /opt/packages

cd /opt/packages


echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list


curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -


apt-get update

apt-get install -y cassandra

apt-get install -y dsc22

apt-get install -y cassandra-tools

service cassandra stop

rm -rf /var/lib/cassandra/data/system/*

