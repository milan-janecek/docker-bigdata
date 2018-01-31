#!/bin/bash

echo "STARTING MAPREDHISTORYSERVER"

# EXPOSED PORTS
#
# 10020 - mapredhistoryserver ipc port => mapreduce.jobhistory.address
# 19888 - mapredhistoryserver http ui => mapreduce.jobhistory.webapp.address

docker run -dit \
  --name mapredh \
  --hostname mapredh \
  --network=cluster \
  --expose 10020 -p 10020:10020 \
  --expose 19888 -p 19888:19888 \
  --mount type=bind,source=/vagrant/hadoop/share,target=/share \
  hadoop /share/start-mapredhistoryserver.sh