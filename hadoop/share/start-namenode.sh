#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"
cp -v /share/conf/* $HADOOP_HOME/etc/hadoop

if [ ! -f /edits/.already_formatted ]; then
  
  echo "FORMATTING NAMENODE"
  hdfs namenode -format -force
  
  touch /edits/.already_formatted
  
elif [ ! -f /edits/.already_bootstrapped ]; then
  
  echo "BOOTSTRAPING STANDBY NAMENODE"  
  hdfs namenode -bootstrapStandby -force
 
  echo "FORMATTING ZOOKEEPER NAMENODE HA"
  hdfs zkfc -formatZK
 
  touch /edits/.already_bootstrapped
  
fi

hdfs namenode