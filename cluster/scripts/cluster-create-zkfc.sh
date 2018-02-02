#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of a ZKFC."
  exit 1
fi

number=$1

echo "STARTING ZKFC $number"

base_dir=$(dirname $0)/../..

docker run -dit \
  --name zkfc${number} \
  --network=container:nn${number} \
  --mount type=bind,source=$base_dir/software/hadoop/share,target=/share \
  hadoop:$HADOOP_VER /share/start-zkfc.sh