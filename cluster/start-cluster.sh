#!/bin/bash

echo "*** STARTING CLUSTER ***"

echo "STARTING NAMENODE 1"
docker container start nn1

echo "WAITING 5 SECONDS FOR NAMENODE 1 TO START"
sleep 5

echo "STARTING NAMENODE 2"
docker container start nn2

echo "WAITING 5 SECONDS FOR NAMENODE 2 TO START"
sleep 5

echo "FAILOVER TO NAMENODE 1"
docker run --rm \
  --network=cluster \
  --mount type=bind,source=/vagrant/share,target=/share \
  hadoop /share/execute.sh hdfs haadmin -failover --forcefence --forceactive nn2 nn1

echo "STARTING DATANODE 1"
docker container start w1

echo "STARTING DATANODE 2"
docker container start w2

echo "STARTING DATANODE 3"
docker container start w3