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
# datanode + nodemanager + hregionserver are collocated = share the same network interface
#
# DATANODE
# 
# 9864 - datanode http ui => dfs.datanode.http.address
# 9866 - datanode data transfer port => dfs.datanode.address
# 9867 - datanode ipc port => dfs.datanode.ipc.address
#
# NODEMANAGER
#
# 8042 - nodemanager http ui => yarn.nodemanager.webapp.address
# 8040 - localizer ipc port => yarn.nodemanager.localizer.address
# 8048 - collector service ipc port => yarn.nodemanager.collector-service.address
#
# 1st node gets default ports, 2nd node gets ports prefixed by 1 and so on
#
# HREGIONSERVER
#
# 16020 - the port the hregionserver should bind to => hbase.regionserver.port
# 16030 - hmaster http ui => hbase.regionserver.info.port
#
# 1st node gets default ports, 2nd node gets default ports + 1 and so on

port_inc=$number
let "port_inc -= 1"

hregionsrv_port=16020
let "hregionsrv_port += $port_inc"
hregionsrv_webui_port=16030
let "hregionsrv_webui_port += $port_inc"

base_dir=$(dirname $0)/../..

docker run -dit \
  --name dn${number} \
  --hostname dn${number}.cluster \
  --network=cluster \
  --expose ${prefix}9864 -p ${prefix}9864:${prefix}9864 \
  --expose ${prefix}9866 -p ${prefix}9866:${prefix}9866 \
  --expose ${prefix}9867 -p ${prefix}9867:${prefix}9867 \
  --expose ${prefix}8042 -p ${prefix}8042:${prefix}8042 \
  --expose ${prefix}8040 -p ${prefix}8040:${prefix}8040 \
  --expose ${prefix}8048 -p ${prefix}8048:${prefix}8048 \
  --expose $hregionsrv_port -p $hregionsrv_port:$hregionsrv_port \
  --expose $hregionsrv_webui_port -p $hregionsrv_webui_port:$hregionsrv_webui_port \
  --mount source=dn${number}-data,target=/data \
  --mount type=bind,source=$base_dir/software/hadoop/share,target=/share \
  hadoop:$HADOOP_VER /share/start-datanode.sh