#!/bin/bash

###############################################################
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
###############################################################

# --- HISOTRY -------------------------------------------------
# 15-oct-15 : for mesos.
# -------------------------------------------------------------

export LC_ALL=C


# add spark user
groupadd -g 501 spark

useradd -u 501 -g spark -s /bin/bash -m spark


# install spark package
mkdir -p /opt/packages

cd /opt/packages

wget http://ftp.riken.jp/net/apache/spark/spark-1.5.1/spark-1.5.1-bin-hadoop2.4.tgz

tar xfz spark-1.5.1-bin-hadoop2.4.tgz

chown -R spark.spark spark-1.5.1-bin-hadoop2.4

ln -s /opt/packages/spark-1.5.1-bin-hadoop2.4 /opt/spark

cp -p /opt/spark/conf/log4j.properties.template /opt/spark/conf/log4j.properties

sed -i.bak -e "s/^log4j\.rootCategory\s*=\s*INFO.*/log4j.rootCategory=WARN, console/" /opt/spark/conf/log4j.properties

echo 'export PATH=$PATH:/opt/spark/bin' > /home/spark/.bash_profile
chown spark.spark /home/spark/.bash_profile

exit 0
