#!/bin/bash

###############################################################
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
###############################################################

# --- HISOTRY -------------------------------------------------
# -------------------------------------------------------------

export LC_ALL=C


# add spark user
groupadd -g 502 drill

useradd -u 502 -g drill -s /bin/bash -m drill


mkdir -p /opt/packages

cd /opt/packages

wget http://getdrill.org/drill/download/apache-drill-1.1.0.tar.gz

tar xfz apache-drill-1.1.0.tar.gz

chown -R drill.drill /opt/packages/apache-drill-1.1.0

ln -s /opt/packages/apache-drill-1.1.0 /opt/drill

#conf/drill-overrider.conf

#drill.exec: {
#  cluster-id: "drillbits1",
#  zk.connect: "119.81.160.205:2181"
#  #zk.connect: "localhost:2181"
#}

#./bin/drillbit.sh start

echo 'unset JAVA_HOME' > /home/drill/.bash_profile
echo 'export PATH=/usr/bin:$PATH' >> /home/drill/.bash_profile

echo 'export PATH=$PATH:/opt/drill/bin' >> /home/drill/.bash_profile

chown drill.drill /home/drill/.bash_profile
