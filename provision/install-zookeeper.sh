#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ $# -ne 3 ]; then
  echo "ERROR: Exactly 3 arguments are needed: mirror, version, sha1_checksum."
  exit 1
fi

mirror=$1
ver=$2
sha1_checksum=$3

echo "*** SCRIPT ARGUMENTS ***"
echo "mirror: $1"
echo "version: $2"
echo "sha1_checksum: $3"

echo "*** INSTALLING ZOOKEEPER $ver ***"

if [ ! -d /usr/local/zookeeper-$ver ]; then

  if [ ! -f $BASE_DIR/software/zookeeper/zookeeper-$ver.tar.gz ]; then
    echo "DOWNLOADING ZOOKEEPER"
    sudo curl -o $BASE_DIR/software/zookeeper/zookeeper-$ver.tar.gz \
      $mirror/zookeeper-$ver/zookeeper-$ver.tar.gz
	
    echo "VALIDATING CHECKSUM"
    echo "$sha1_checksum $BASE_DIR/software/zookeeper/zookeeper-$ver.tar.gz" | sha1sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rem -rf $BASE_DIR/software/zookeeper/zookeeper-$ver.tar.gz
      echo "CHECKSUM VALIDATION FAILED - ZOOKEEPER $ver HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
	
  echo "EXTRACTING ZOOKEEPER ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/zookeeper/zookeeper-$ver.tar.gz -C /usr/local
    
  echo "ZOOKEEPER $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED" 
else
  echo "ZOOKEEPER $ver IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE ZOOKEEPER $ver ***"
profileFile="/etc/profile.d/zookeeper.sh"
sudo rm -rf $profileFile
addLineToFile "export ZOOKEEPER_HOME=/usr/local/zookeeper-$ver" $profileFile
addLineToFile 'export PATH=$PATH:$ZOOKEEPER_HOME/bin' $profileFile
addLineToFile "export ZOOKEEPER_VER=$ver" $profileFile