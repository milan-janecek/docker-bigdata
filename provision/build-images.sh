#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}

if [ -f $BASE_DIR/provision/configs/config.sh ]; then
  source $BASE_DIR/provision/configs/config.sh
else
  source $BASE_DIR/provision/configs/default-config.sh
fi

docker build --build-arg VER=$HADOOP_VER \
  --build-arg SUPER_GROUP_USER=$(whoami) \
  -t hadoop:$HADOOP_VER \
  $BASE_DIR/software/hadoop

docker build --build-arg VER=$ZOOKEEPER_VER \
 -t zookeeper:$ZOOKEEPER_VER \
 $BASE_DIR/software/zookeeper

docker build --build-arg VER=$HBASE_VER \
 --build-arg HADOOP_VER=$HADOOP_VER \
 -t hbase:${HBASE_VER}_${HADOOP_VER} \
 $BASE_DIR/software/hbase
 
docker build --build-arg VER=$SPARK_VER \
 --build-arg HADOOP_VER=$HADOOP_VER \
 -t spark:${SPARK_VER}_${HADOOP_VER} \
 $BASE_DIR/software/spark