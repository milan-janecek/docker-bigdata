#!/bin/bash

echo "*** CREATING CLUSTER ***"

# CONFIGURING CONTAINERS
#
# each container gets a bind mount with configuration files mounted to /share

# USER DEFINED NETWORK
#
# all containers are connected to this network

echo "CREATING CLUSTER NETWORK"
docker network create cluster

# HADOOP ports - convention
#
# first instance of a hadoop daemon gets default hadoop ports, second instance 
# of the hadoop daemon gets default hadoop ports prefixed with 1, third instance
# gets default hadoop ports prefixed with 2 and so on 

# HADOOP NAMENODES
# 
# 2 namenodes are in HA mode using shared folder
# 
# 9820 - namenode rpc port => dfs.namenode.rpc-address
# 9870 - namenode http ui => dfs.namenode.http-address
 
# create volume to be used as edits folder for HA

echo "CREATING EDITS DIR FOR NAMENODES HA"
docker volume create edits

echo "STARTING NAMENODE 1"
docker run -dit \
  --name nn1 \
  --hostname nn1 \
  --network=cluster \
  --expose 9820 -p 9820:9820 \
  --expose 9870 -p 9870:9870 \
  --mount source=nn1-data,target=/data \
  --mount source=edits,target=/edits \
  --mount type=bind,source=/vagrant/share,target=/share \
  hadoop /share/start-namenode.sh

echo "WAITING 5 SECONDS FOR NAMENODE 1 TO START"
sleep 5
  
echo "STARTING NAMENODE 2"
docker run -dit \
  --name nn2 \
  --hostname nn2 \
  --network=cluster \
  --expose 19820 -p 19820:19820 \
  --expose 19870 -p 19870:19870 \
  --mount source=nn2-data,target=/data \
  --mount source=edits,target=/edits \
  --mount type=bind,source=/vagrant/share,target=/share \
  hadoop /share/start-namenode.sh

echo "WAITING 5 SECONDS FOR NAMENODE 2 TO START"
sleep 5
  
echo "FAILOVER TO NAMENODE 1"
docker run --rm \
  --network=cluster \
  --mount type=bind,source=/vagrant/share,target=/share \
  hadoop /share/execute.sh hdfs haadmin -failover --forcefence --forceactive nn2 nn1
  
# HADOOP DATANODES
#
# 9864 - datanode http ui => dfs.datanode.http.address
# 9866 - datanode data transfer port => dfs.datanode.address
# 9867 - datanode ipc port => dfs.datanode.ipc.address

echo "STARTING DATANODE 1"
docker run -dit \
  --name w1 \
  --hostname w1 \
  --network=cluster \
  --expose 9864 -p 9864:9864 \
  --expose 9866 -p 9866:9866 \
  --expose 9867 -p 9867:9867 \
  --mount source=dn1-data,target=/data \
  --mount type=bind,source=/vagrant/share,target=/share \
  hadoop /share/start-datanode.sh

echo "STARTING DATANODE 2"
docker run -dit \
  --name w2 \
  --hostname w2 \
  --network=cluster \
  --expose 19864 -p 19864:19864 \
  --expose 19866 -p 19866:19866 \
  --expose 19867 -p 19867:19867 \
  --mount source=dn2-data,target=/data \
  --mount type=bind,source=/vagrant/share,target=/share \
  hadoop /share/start-datanode.sh
  
echo "STARTING DATANODE 3"
docker run -dit \
  --name w3 \
  --hostname w3 \
  --network=cluster \
  --expose 29864 -p 29864:29864 \
  --expose 29866 -p 29866:29866 \
  --expose 29867 -p 29867:29867 \
  --mount source=dn3-data,target=/data \
  --mount type=bind,source=/vagrant/share,target=/share \
  hadoop /share/start-datanode.sh
