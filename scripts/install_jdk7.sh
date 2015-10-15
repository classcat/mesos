#!/bin/bash

########################################################################
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
########################################################################

#--- HISTORY ----------------------------------------------------------
# 15-oct-15 : changed the path.
# 15-oct-15 : fixed.
#----------------------------------------------------------------------


export LC_ALL=C

CWD=`pwd`

mkdir -p /opt/packages

cd /opt/packages

wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz

tar xfz jdk-7u79-linux-x64.tar.gz

mkdir -p /usr/lib/jvm

mv jdk1.7.0_79 /usr/lib/jvm

cat << _EOB_ > /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_79
export PATH=\$JAVA_HOME/bin:\$PATH
#export PATH=\$PATH:\$JAVA_HOME/bin
_EOB_


exit 0
