#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ -f $BASE_DIR/provision/configs/config.sh ]; then
  source $BASE_DIR/provision/configs/config.sh
else
  source $BASE_DIR/provision/configs/default-config.sh
fi

APACHE_MIRROR=$APACHE_MIRROR/zookeeper

echo "*** INSTALLING ZOOKEEPER $ZOOKEEPER_VER ***"

if [ ! -d /usr/local/zookeeper-$ZOOKEEPER_VER ]; then

  if [ ! -f $BASE_DIR/software/zookeeper/zookeeper-$ZOOKEEPER_VER.tar.gz ]; then
    echo "DOWNLOADING ZOOKEEPER"
    sudo curl -o $BASE_DIR/software/zookeeper/zookeeper-$ZOOKEEPER_VER.tar.gz \
      $APACHE_MIRROR/zookeeper-$ZOOKEEPER_VER/zookeeper-$ZOOKEEPER_VER.tar.gz
	
    echo "VALIDATING CHECKSUM"
    echo "$ZOOKEEPER_SHA1_CHECKSUM $BASE_DIR/software/zookeeper/zookeeper-$ZOOKEEPER_VER.tar.gz" | sha1sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rem -rf $BASE_DIR/software/zookeeper/zookeeper-$ZOOKEEPER_VER.tar.gz
      echo "CHECKSUM VALIDATION FAILED - ZOOKEEPER $ZOOKEEPER_VER HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
	
  echo "EXTRACTING ZOOKEEPER ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/zookeeper/zookeeper-$ZOOKEEPER_VER.tar.gz -C /usr/local
    
  echo "ZOOKEEPER $ZOOKEEPER_VER HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED"
else
  echo "ZOOKEEPER $ZOOKEEPER_VER IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE ZOOKEEPER $ZOOKEEPER_VER ***"
addEnvVarExportToFile ZOOKEEPER_HOME /usr/local/zookeeper-$ZOOKEEPER_VER /etc/profile
addLineToFile 'export PATH=$PATH:$ZOOKEEPER_HOME/bin' /etc/profile
addEnvVarExportToFile ZOOKEEPER_VER $ZOOKEEPER_VER /etc/profile