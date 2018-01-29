#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of a namenode."
  exit 1
fi

number=$1

echo "STARTING NAMENODE $number"

prefix=$number
let "prefix -= 1"

if [ "$prefix" -eq "0" ]; then
  prefix=""
fi

# EXPOSED PORTS
#
# 9820 - namenode rpc port => dfs.namenode.rpc-address
# 9870 - namenode http ui => dfs.namenode.http-address
#
# 1st node gets default ports, 2nd node gets ports prefixed by 1 and so on

docker run -dit \
  --name nn${number} \
  --hostname nn${number} \
  --network=cluster \
  --expose ${prefix}9820 -p ${prefix}9820:${prefix}9820 \
  --expose ${prefix}9870 -p ${prefix}9870:${prefix}9870 \
  --mount source=nn${number}-data,target=/data \
  --mount source=edits,target=/edits \
  --mount type=bind,source=/vagrant/hadoop/share,target=/share \
  hadoop /share/start-namenode.sh