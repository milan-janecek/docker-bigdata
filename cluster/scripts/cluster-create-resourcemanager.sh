#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of a resourcemanager."
  exit 1
fi

number=$1

echo "STARTING RESOURCEMANAGER $number"

prefix=$number
let "prefix -= 1"

if [ "$prefix" -eq "0" ]; then
  prefix=""
fi

# EXPOSED PORTS
#
# 8088 - resourcemanager http ui => yarn.resourcemanager.webapp.address
# 8030 - address of the scheduler => yarn.resourcemanager.scheduler.address
# 8031 - address of the resource tracker => yarn.resourcemanager.resource-tracker.address
# 8032 - address of the applications manager interface => yarn.resourcemanager.address
# 8033 - address of the admin interface => yarn.resourcemanager.admin.address
#
# 1st node gets default ports, 2nd node gets ports prefixed by 1 and so on

docker run -dit \
  --name rm${number} \
  --hostname rm${number} \
  --network=cluster \
  --expose ${prefix}8088 -p ${prefix}8088:${prefix}8088 \
  --expose ${prefix}8030 -p ${prefix}8030:${prefix}8030 \
  --expose ${prefix}8031 -p ${prefix}8031:${prefix}8031 \
  --expose ${prefix}8032 -p ${prefix}8032:${prefix}8032 \
  --expose ${prefix}8033 -p ${prefix}8033:${prefix}8033 \
  --mount source=rm${number}-data,target=/data \
  --mount type=bind,source=/vagrant/hadoop/share,target=/share \
  hadoop /share/start-resourcemanager.sh