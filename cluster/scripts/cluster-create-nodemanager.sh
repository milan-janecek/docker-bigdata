#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: Script needs one argument => number of a nodemanager."
  exit 1
fi

number=$1

echo "STARTING NODEMANAGER $number"

docker run -dit \
  --name nm${number} \
  --network=container:dn${number} \
  --mount source=nm${number}-data,target=/data \
  --mount type=bind,source=/vagrant/hadoop/share,target=/share \
  hadoop /share/start-nodemanager.sh