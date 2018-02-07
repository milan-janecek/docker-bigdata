#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of a zookeeper."
  exit 1
fi

number=$1

echo "STARTING ZOOKEEPER $number"

prefix=$number
let "prefix -= 1"

if [ "$prefix" -eq "0" ]; then
  prefix=""
fi

# EXPOSED PORTS
#
# 2181 - port to listen for client connections
# 2888 - zookeeper internal communication port
# 3888 - zookeeper internal communication port
#
# 1st node gets default ports, 2nd node gets ports prefixed by 1 and so on

base_dir=$(dirname $0)/../..

docker run -dit \
  --name zoo${number} \
  --hostname zoo${number}.cluster \
  --network=cluster \
  --expose ${prefix}2181 -p ${prefix}2181:${prefix}2181 \
  --expose ${prefix}2888 -p ${prefix}2888:${prefix}2888 \
  --expose ${prefix}3888 -p ${prefix}3888:${prefix}3888 \
  --mount source=zoo${number}-data,target=/data \
  --mount type=bind,source=$base_dir/software/zookeeper/share,target=/share \
  zookeeper:$ZOOKEEPER_VER /share/start-zookeeper.sh