#!/bin/bash

BASE_DIR=${BASE_DIR:-$(pwd)/..}
source $BASE_DIR/cluster/scripts/functions.sh

addLineToFile 'export PATH=$PATH:'$BASE_DIR'/cluster' /etc/profile
chmod +x $BASE_DIR/cluster/cluster
chmod +x $BASE_DIR/cluster/scripts/datanode
chmod +x $BASE_DIR/cluster/scripts/hmaster
chmod +x $BASE_DIR/cluster/scripts/hregionserver
chmod +x $BASE_DIR/cluster/scripts/mapredhistoryserver
chmod +x $BASE_DIR/cluster/scripts/namenode
chmod +x $BASE_DIR/cluster/scripts/nodemanager
chmod +x $BASE_DIR/cluster/scripts/resourcemanager
chmod +x $BASE_DIR/cluster/scripts/sparkhistoryserver
chmod +x $BASE_DIR/cluster/scripts/timelineserver
chmod +x $BASE_DIR/cluster/scripts/worker
chmod +x $BASE_DIR/cluster/scripts/zkfc
chmod +x $BASE_DIR/cluster/scripts/zookeeper
