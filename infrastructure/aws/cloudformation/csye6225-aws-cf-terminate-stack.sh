#!/bin/bash

set -e
##Check if enough arguements are passed
if [ $# -lt 1 ]; then
  echo -e 1>&2 "Stack name missing\nrun $0 <stack_name>"
  exit 2
elif [ $# -gt 1 ]; then
  echo -e 1>&2 "Too many Arguments\nrun $0 <stack_name>"
  exit 2
fi

STACK_NAME=$1

if ! aws cloudformation describe-stacks --stack-name $STACK_NAME &> /dev/null; then
    echo "Stack $STACK_NAME does not exist"
    exit 1
fi


##Deleting Stack
echo "Deletion in progress.."
aws cloudformation delete-stack --stack-name $STACK_NAME

aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME

if [ $? -ne 0 ]; then
	echo "Stack $STACK_NAME deletion failed!"
    exit 1
fi

echo "Stack $STACK_NAME deleted successfully!"
