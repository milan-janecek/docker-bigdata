#!/bin/bash

BASE_DIR=${BASE_DIR:-$(pwd)/..}

docker build --build-arg VER=$HADOOP_VER \
  -t hadoop:$HADOOP_VER \
  $BASE_DIR/software/hadoop

docker build --build-arg VER=$ZOOKEEPER_VER \
 -t zookeeper:$ZOOKEEPER_VER \
 $BASE_DIR/software/zookeeper
 
# TODO: builds hbase 
# docker build --build-arg VER=1.2.6 --build-arg HADOOP_VER=2.7.5 -t hbase:1.2.6 -f /vagrant/software/hbase/Dockerfile /vagrant