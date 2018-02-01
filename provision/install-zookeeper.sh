#!/bin/bash

mirror=$1
ver=$2
checksum=$3

echo "INSTALLING ZOOKEEPER"

echo "DOWNLOADING ZOOKEEPER $2 from $1"

sudo curl -o /vagrant/zookeeper/zookeeper.tar.gz \
  $mirror/zookeeper-$ver/zookeeper-$ver.tar.gz
  
echo "VALIDATING CHECKSUM"

echo "$checksum /vagrant/zookeeper/zookeeper.tar.gz" | sha1sum -c -
exit_status=$?
if [ $exit_status -ne 0 ]; then
  echo "CHECKSUM VALIDATION FAILED"
  exit $exit_status
else
  echo "CHECKSUM IS OK"
fi

echo "EXTRACTING ZOOKEEPER ARCHIVE TO /usr/local/zookeeper"

tar -zxf /vagrant/zookeeper/zookeeper.tar.gz -C /usr/local
sudo mv /usr/local/zookeeper-* /usr/local/zookeeper

echo "MODIFYING ENVIRONMENT VARIABLES"

sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/zookeeper/bin >> /etc/profile.d/vagrant.sh'
  
echo "COPYING ZOOKEEPER CONFIGURATION FILES FROM SHARE TO ZOOKEEPER CONF DIR"

sudo cp -v /vagrant/zookeeper/share/conf/* /usr/local/zookeeper/conf

