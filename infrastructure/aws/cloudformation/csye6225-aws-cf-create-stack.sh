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

STACK_NAME=$1

##Creating Stack
aws cloudformation create-stack --stack-name "$STACK_NAME" --template-body file://csye6225-cf-networking.json --parameters file://parameters.json
echo "Creation in progress.."

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

if [ $? -ne 0 ]; 
then
	echo "Stack $STACK_NAME creation failed!"
    exit 1
fi

echo "stack $STACK_NAME is created successfully!"