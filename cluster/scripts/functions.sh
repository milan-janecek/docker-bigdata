#!/bin/bash

function addLineToFile() {
  # $1 is line
  # $2 is file
  echo "Adding \"$1\" to \"$2\"."
  grep -q -F "$1" $2 || echo $1 | sudo tee -a $2
}