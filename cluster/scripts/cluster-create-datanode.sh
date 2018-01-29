#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of a datanode."
  exit 1
fi

number=$1

echo "STARTING DATANODE $number"

prefix=$number
let "prefix -= 1"

if [ "$prefix" -eq "0" ]; then
  prefix=""
fi

# EXPOSED PORTS
#
# 9864 - datanode http ui => dfs.datanode.http.address
# 9866 - datanode data transfer port => dfs.datanode.address
# 9867 - datanode ipc port => dfs.datanode.ipc.address
#
# 1st node gets default ports, 2nd node gets ports prefixed by 1 and so on

docker run -dit \
  --name w${number} \
  --hostname w${number} \
  --network=cluster \
  --expose ${prefix}9864 -p ${prefix}9864:${prefix}9864 \
  --expose ${prefix}9866 -p ${prefix}9866:${prefix}9866 \
  --expose ${prefix}9867 -p ${prefix}9867:${prefix}9867 \
  --mount source=dn${number}-data,target=/data \
  --mount type=bind,source=/vagrant/hadoop/share,target=/share \
  hadoop /share/start-datanode.sh