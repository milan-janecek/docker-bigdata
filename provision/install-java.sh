#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ -f $BASE_DIR/provision/configs/config.sh ]; then
  source $BASE_DIR/provision/configs/config.sh
else
  source $BASE_DIR/provision/configs/default-config.sh
fi

filename=$(basename $ORACLE_JDK_URL)
ver=$(echo $filename | sed -r 's/(\w+)-([0-9a-ZA-Z]+)-(.+)/\1-\2/')

echo "*** INSTALLING JAVA $ver ***"

if [ ! -d /usr/local/$ver ]; then

  if [ ! -f $BASE_DIR/software/java/$filename ]; then
    echo "DOWNLOADING JAVA" 
    curl -jkSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
      -o $BASE_DIR/software/java/$filename $ORACLE_JDK_URL
  
    echo "VALIDATING CHECKSUM"
    echo "$ORACLE_JDK_SHA256_CHECKSUM $BASE_DIR/software/java/$filename" | sha256sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/java/$filename
      echo "CHECKSUM VALIDATION FAILED - JAVA $ver HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING JAVA ARCHIVE"
  sudo mkdir -p /usr/local/$ver
  sudo tar -zxf $BASE_DIR/software/java/$filename -C /usr/local/$ver
  sudo mv /usr/local/$ver/*/* /usr/local/$ver
  
  echo "JAVA $ver HAS BEEN SUCCESSFULLY INSTALLED"
else
  echo "JAVA $ver IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE JAVA $ver ***"
addEnvVarExportToFile JAVA_HOME /usr/local/$ver /etc/profile
addLineToFile 'export PATH=$PATH:$JAVA_HOME/bin' /etc/profile