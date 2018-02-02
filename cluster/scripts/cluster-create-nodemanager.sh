#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of a nodemanager."
  exit 1
fi

number=$1

echo "STARTING NODEMANAGER $number"

base_dir=$(dirname $0)/../..

docker run -dit \
  --name nm${number} \
  --network=container:dn${number} \
  --mount source=nm${number}-data,target=/data \
  --mount type=bind,source=$base_dir/software/hadoop/share,target=/share \
  hadoop:$HADOOP_VER /share/start-nodemanager.sh