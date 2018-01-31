#!/bin/bash

mirror=$1
ver=$2
checksum=$3

echo "*** INSTALLING HADOOP ***"

echo "DOWNLOADING HADOOP $2 from $1"

#sudo curl -o /vagrant/hadoop/hadoop.tar.gz \
#  $mirror/hadoop-$ver/hadoop-$ver.tar.gz

echo "VALIDATING CHECKSUM"

echo "$checksum /vagrant/hadoop/hadoop.tar.gz" | sha1sum -c -
exit_status=$?
if [ $exit_status -ne 0 ]; then
  echo "CHECKSUM VALIDATION FAILED"
  exit $exit_status
else
  echo "CHECKSUM IS OK"
fi

echo "EXTRACTING HADOOP ARCHIVE TO /usr/local/hadoop"

tar -zxf /vagrant/hadoop/hadoop.tar.gz -C /usr/local
sudo mv /usr/local/hadoop-* /usr/local/hadoop

echo "MODIFYING ENVIRONMENT VARIABLES"

sudo sh -c \
  'echo export HADOOP_HOME=/usr/local/hadoop > /etc/profile.d/hadoop-home.sh'
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/hadoop/bin > /etc/profile.d/hadoop-path.sh'
  
echo "COPYING CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"

cp -v /vagrant/hadoop/share/conf/* /usr/local/hadoop/etc/hadoop




