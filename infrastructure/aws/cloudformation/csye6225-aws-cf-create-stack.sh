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

if aws cloudformation describe-stacks --stack-name $STACK_NAME &> /dev/null; then
    echo "Stack $STACK_NAME already exists"
    exit 1
fi

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