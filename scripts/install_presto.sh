#!/bin/bash

###############################################################
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
###############################################################

# --- HISOTRY -------------------------------------------------
# 15-oct-15 : chmod +x presto-cli.
# -------------------------------------------------------------

export LC_ALL=C

. ../conf/presto.conf

ETC_DIR=/opt/presto-server/etc
DATA_DIR=/var/presto/data

CWD=`pwd`


mkdir -p /opt/packages

cd /opt/packages

wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.122/presto-server-0.122.tar.gz

tar xfz presto-server-0.122.tar.gz

chown -R root.root presto-server-0.122

ln -s /opt/packages/presto-server-0.122 /opt/presto-server



mkdir -p $ETC_DIR

mkdir -p $DATA_DIR

cat << _EOB_ > $ETC_DIR/node.properties
node.environment=production
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
node.data-dir=/var/presto/data
_EOB_

cat << _EOB2_ > $ETC_DIR/jvm.config
-server
-Xmx16G
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+UseGCOverheadLimit
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:OnOutOfMemoryError=kill -9 %p
_EOB2_

if [ $COORDINATOR == "true" ]; then

  cat << _EOB3_ > $ETC_DIR/config.properties
coordinator=true
node-scheduler.include-coordinator=false
http-server.http.port=8080
query.max-memory=50GB
query.max-memory-per-node=1GB
discovery-server.enabled=true
discovery.uri=${COORDINATOR_URI}
_EOB3_

  cat << _EOB3B_ > $ETC_DIR/config.properties.local
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
query.max-memory=5GB
query.max-memory-per-node=1GB
discovery-server.enabled=true
discovery.uri=${COORDINATOR_URI}
_EOB3B_

else

  cat << _EOB3_ > $ETC_DIR/config.properties
coordinator=false
http-server.http.port=8080
query.max-memory=50GB
query.max-memory-per-node=1GB
discovery.uri=${COORDINATOR_URI}
_EOB3_

fi

  cat << _EOB4_ > $ETC_DIR/log.properties
com.facebook.presto=INFO
_EOB4_


mkdir -p $ETC_DIR/catalog

  cat << _EOB5_ > $ETC_DIR/catalog/cassandra.properties
connector.name=cassandra
cassandra.contact-points=${CASSANDRA_HOST}
_EOB5_


### CLI

cd /usr/local/bin

wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.122/presto-cli-0.122-executable.jar


ln -s /usr/local/bin/presto-cli-0.122-executable.jar /usr/local/bin/presto-cli

chmod +x /usr/local/bin/presto-cli-0.122-executable.jar



