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

##Deleting Stack
echo "Deletion in progress.."
aws cloudformation delete-stack --stack-name $STACK_NAME

aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME

if [ $? -ne 0 ]; 
then
	echo "Stack $STACK_NAME deletion failed!"
    exit 1
fi

echo "Stack $STACK_NAME deleted successfully!"
