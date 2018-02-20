#!/bin/bash

function addLineToFile() {
  # $1 is line
  # $2 is file
  echo "Adding \"$1\" to \"$2\"."
  grep -q -F "$1" $2 || echo $1 | sudo tee -a $2
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