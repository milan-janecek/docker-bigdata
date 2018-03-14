#!/bin/bash

function addLineToFile() {
  # $1 is line
  # $2 is file
  echo "Adding \"$1\" to \"$2\"."
  grep -q -F "$1" $2 &>/dev/null || echo $1 | sudo tee -a $2 &>/dev/null
}

function addEnvVarExportToFile() {
  # $1 is environment variable
  # $2 is value of environment variable
  # $3 is file
  echo "Adding \"$1\" with value \"$2\" to \"$3\"."ca
  grep -q -F "$1" $3 &>/dev/null
  if [ $? -eq 0 ]; then
    new_content=$(sed "s#export $1=.*#export $1=$2#" $3)
    echo "$new_content" | sudo tee $3 &>/dev/null
  fi
  grep -q -F "$1" $3 &>/dev/null || echo "export $1=$2" | sudo tee -a $3 &>/dev/null
}

function removeLineContaining() {
  # $1 is string to be searched for
  # $2 is file
  new_content=$(sed "/$1/d" $2)
  echo "$new_content" | sudo tee $2 &>/dev/null
}

function addContainerToHostsFile() {
  # $1 is container name
  if [ -z "$CLUSTER_ON_MAC" ]; then
    ip=$(docker inspect \
      --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
      $1)
  else
    ip=127.0.0.1
  fi
  sudo sh -c "echo $ip $1.cluster >> /etc/hosts"
}

function print_component_usage() {
  # $1 is component name
  # $2 is flag telling if component is multi-instance one, defaults to true
  multi_instance=${2:-true}
  echo
  if [ "$multi_instance" == "true" ]; then
    echo "Usage: $1 COMMAND NUMBER [CLUSTER CONFIGURATION]"
  else
    echo "Usage: $1 COMMAND [CLUSTER CONFIGURATION]"
  fi
  echo 
  echo "Available commands, create accepts cluster configuration:"
  echo 
  echo "  create"
  echo "  start"
  echo "  stop"
  echo "  delete"
  echo
  echo "Available cluster configurations:"
  echo
  echo "  simple"
  echo "  ha"
  echo
  echo "Default cluster configuration is simple."
  echo
}