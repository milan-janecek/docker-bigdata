#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of an hmaster."
  exit 1
fi

number=$1

echo "STARTING HMASTER $number"

# EXPOSED PORTS
#
# 16000 - the port the hmaster should bind to => hbase.master.port
# 16010 - hmaster http ui => hbase.master.info.port
#
# 1st node gets default ports, 2nd node gets default ports + 1 and so on

port_inc=$number
let "port_inc -= 1"

master_port=16000
let "master_port += $port_inc"
webui_port=16010
let "webui_port += $port_inc"

base_dir=$(dirname $0)/../..

docker run -dit \
  --name hm${number} \
  --hostname hm${number} \
  --network=cluster \
  --expose $master_port -p $master_port:$master_port \
  --expose $webui_port -p $webui_port:$webui_port \
  --mount source=hm${number}-data,target=/data \
  --mount type=bind,source=$base_dir/software/hbase/share,target=/share \
  --mount type=bind,source=$base_dir/software/hadoop/share,target=/hadoop-share \
  hbase:${HBASE_VER}_${HADOOP_VER} /share/start-hmaster.sh