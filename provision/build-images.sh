#!/bin/bash

BASE_DIR=${BASE_DIR:-$(pwd)/..}

docker build --build-arg VER=$HADOOP_VER \
  -t hadoop:$HADOOP_VER \
  $BASE_DIR/software/hadoop

docker build --build-arg VER=$ZOOKEEPER_VER \
 -t zookeeper:$ZOOKEEPER_VER \
 $BASE_DIR/software/zookeeper