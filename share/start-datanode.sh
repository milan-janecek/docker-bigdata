#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"
cp -v /share/conf/* $HADOOP_HOME/etc/hadoop

instance=$(hostname | tr -dc '0-9')
let "instance -= 1"

if [ "$instance" -gt "0" ]; then
  
  echo "MODIFYING DATANODE PORTS"
  
  sed -i "s/0.0.0.0:9864/0.0.0.0:${instance}9864/" \
    $HADOOP_HOME/etc/hadoop/hdfs-site.xml
	
  sed -i "s/0.0.0.0:9866/0.0.0.0:${instance}9866/" \
    $HADOOP_HOME/etc/hadoop/hdfs-site.xml
	
  sed -i "s/0.0.0.0:9867/0.0.0.0:${instance}9867/" \
    $HADOOP_HOME/etc/hadoop/hdfs-site.xml
	
fi

hdfs datanode