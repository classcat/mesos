#!/bin/bash

###############################################################
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
###############################################################

#--- HISTORY ----------------------------------------------------------
#----------------------------------------------------------------------


export LC_ALL=C

. ../conf/cassandra.conf


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

rm -rf /var/lib/cassandra/*

## config

cd $CWD

TARGET=/etc/cassandra/cassandra.yaml

mv $TARGET /etc/cassandra/cassandra.yaml.original

cp -p ../assets/cassandra.yaml.tmpl /etc/cassandra
cp -p /etc/cassandra/cassandra.yaml.tmpl $TARGET

sed -i.bak -e "s/^rpc_address:.*/rpc_address: ${RPC_ADDRESS}/" $TARGET

sed -i -e "s/^listen_address:.*/listen_address: ${LISTEN_ADDRESS}/" $TARGET

sed -i -e "s/^cluster_name:.*/cluster_name: '$CLUSTER_NAME'/" $TARGET

sed -i -e "s/^\s*-\s*seeds:.*/          - seeds: \"$SEEDS\"/" $TARGET

sed -i -e "s/^endpoint_snitch:.*/endpoint_snitch: $SNITCH/" $TARGET


