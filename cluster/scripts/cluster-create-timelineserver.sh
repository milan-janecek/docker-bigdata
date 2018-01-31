#!/bin/bash

echo "STARTING TIMELINESERVER"

# EXPOSED PORTS
#
# 10200 - timelineserver rpc port => yarn.timeline-service.address
# 8188 - timelineserver http ui => yarn.timeline-service.webapp.address

docker run -dit \
  --name ts \
  --hostname ts \
  --network=cluster \
  --expose 10200 -p 10200:10200 \
  --expose 8188 -p 8188:8188 \
  --mount type=bind,source=/vagrant/hadoop/share,target=/share \
  hadoop /share/start-timelineserver.sh