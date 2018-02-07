#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of an hregionserver."
  exit 1
fi

number=$1

echo "STARTING HREGIONSERVER $number"

base_dir=$(dirname $0)/../..

docker run -dit \
  --name hrs${number} \
  --network=container:dn${number} \
  --mount source=hrs${number}-data,target=/data \
  --mount type=bind,source=$base_dir/software/hbase/share,target=/share \
  --mount type=bind,source=$base_dir/software/hadoop/share,target=/hadoop-share \
  hbase:${HBASE_VER}_${HADOOP_VER} /share/start-hregionserver.sh