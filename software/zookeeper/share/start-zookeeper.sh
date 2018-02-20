#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO ZOOKEEPER CONF DIR"
cp -v /share/conf-$CLUSTER_CONFIG/* $ZOOKEEPER_HOME/conf

number=$(hostname | tr -dc '0-9')

echo $number > /data/myid

let "number -= 1"

if [ "$number" -gt "0" ]; then
  
  echo "MODIFYING CLIENT PORT"
  
  sed -i "s/clientPort=2181/clientPort=${number}2181/" \
    $ZOOKEEPER_HOME/conf/zoo.cfg
	
fi

zkServer.sh start-foreground