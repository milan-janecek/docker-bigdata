#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM dockeSHARE TO CONF DIR"
cp -v /share/conf-$CLUSTER_CONFIG/* $HBASE_HOME/conf
cp -v /hadoop-share/conf-$CLUSTER_CONFIG/core-site.xml $HBASE_HOME/conf
cp -v /hadoop-share/conf-$CLUSTER_CONFIG/hdfs-site.xml $HBASE_HOME/conf

export HBASE_ZNODE_FILE=/data/znodefile

port_inc=$(hostname | tr -dc '0-9')
let "port_inc -= 1"

echo "MODIFYING HMASTER PORTS"
hmaster_port=16000
let "hmaster_port += $port_inc"
hmaster_webui_port=16010
let "hmaster_webui_port += $port_inc"
sed -i "s/16000/${hmaster_port}/" $HBASE_HOME/conf/hbase-site.xml
sed -i "s/16010/${hmaster_webui_port}/" $HBASE_HOME/conf/hbase-site.xml

hbase master start