#!/bin/bash

echo "STARTING MAPREDHISTORYSERVER"

# EXPOSED PORTS
#
# 10020 - mapredhistoryserver ipc port => mapreduce.jobhistory.address
# 19888 - mapredhistoryserver http ui => mapreduce.jobhistory.webapp.address

base_dir=$(dirname $0)/../..

docker run -dit \
  --name mapredh \
  --hostname mapredh.cluster \
  --network=cluster \
  --expose 10020 -p 10020:10020 \
  --expose 19888 -p 19888:19888 \
  --mount type=bind,source=$base_dir/software/hadoop/share,target=/share \
  hadoop:$HADOOP_VER /share/start-mapredhistoryserver.sh