#!/bin/bash

version=$1

echo "*** INSTALLING JAVA OPENJDK $1 ***"

sudo apt-get install -y openjdk-$1-jdk

java_home=$(update-alternatives --list java | sed -e "s#/bin/java##") && \

sudo sh -c \
  "echo export JAVA_HOME=$java_home > /etc/profile.d/java-home.sh"




