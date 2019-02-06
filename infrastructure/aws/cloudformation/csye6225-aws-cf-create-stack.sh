#!/bin/bash

set -e
##Check if enough arguements are passed
if [ $# -lt 1 ]; then
  echo 1>&2 "$0: Stack name not provided"
  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "$0: Too many Arguments"
  exit 2
fi


##Creating Stack
aws cloudformation create-stack --stack-name "$1" --template-body file://csye6225-cf-networking.json --parameters file://parameters.json
aws cloudformation wait stack-create-complete --stack-name $1
echo "stack $1 is created"