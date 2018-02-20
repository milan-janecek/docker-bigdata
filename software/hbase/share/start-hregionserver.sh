#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO CONF DIR"
cp -v /share/conf-$CLUSTER_CONFIG/* $HBASE_HOME/conf
cp -v /hadoop-share/conf-$CLUSTER_CONFIG/core-site.xml $HBASE_HOME/conf
cp -v /hadoop-share/conf-$CLUSTER_CONFIG/hdfs-site.xml $HBASE_HOME/conf

export HBASE_ZNODE_FILE=/data/znodefile

port_inc=$(hostname | tr -dc '0-9')
let "port_inc -= 1"

echo "MODIFYING HREGIONSERVER PORTS"
hregionsrv_port=16020
let "hregionsrv_port += $port_inc"
hregionsrv_webui_port=16030
let "hregionsrv_webui_port += $port_inc"
sed -i "s/16020/${hregionsrv_port}/" $HBASE_HOME/conf/hbase-site.xml
sed -i "s/16030/${hregionsrv_webui_port}/" $HBASE_HOME/conf/hbase-site.xml

hbase regionserver start