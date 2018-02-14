#!/bin/bash

if [ $# -ne 3 ]; then
  echo "ERROR: Exactly 3 arguments are needed: mirror, version, sha1_checksum."
  exit 1
fi

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}

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
  
  echo "COPYING ZOOKEEPER CONFIGURATION FILES FROM SHARE TO ZOOKEEPER CONF DIR"
  sudo cp -v $BASE_DIR/software/zookeeper/share/conf/* /usr/local/zookeeper-$ver/conf
    
  echo "ZOOKEEPER $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED" 
else
  echo "ZOOKEEPER $ver IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE ZOOKEEPER $ver ***"
echo "ADDING ZOOKEEPER BIN TO PATH"
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/zookeeper-'$ver'/bin > /etc/profile.d/zookeeper-bin.sh'
  
echo "SETTING ZOOKEEPER_VER"
sudo sh -c \
  "echo export ZOOKEEPER_VER=$ver > /etc/profile.d/zookeeper-ver.sh"