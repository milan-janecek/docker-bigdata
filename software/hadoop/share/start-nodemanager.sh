#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"
cp -v /share/conf-$CLUSTER_CONFIG/* $HADOOP_HOME/etc/hadoop

prefix=$(hostname | tr -dc '0-9')
let "prefix -= 1"

if [ "$prefix" -gt "0" ]; then
  
  echo "MODIFYING NODEMANAGER PORTS"
  
  sed -i "s/0.0.0.0:8042/0.0.0.0:${prefix}8042/" \
    $HADOOP_HOME/etc/hadoop/yarn-site.xml
	
  sed -i "s/0.0.0.0:8040/0.0.0.0:${prefix}8040/" \
    $HADOOP_HOME/etc/hadoop/yarn-site.xml
	
  sed -i "s/0.0.0.0:8048/0.0.0.0:${prefix}8048/" \
    $HADOOP_HOME/etc/hadoop/yarn-site.xml
	
fi

yarn nodemanager