#!/bin/bash

BASEDIR=$(dirname "$0")
PARAM_FILE_PATH=$BASEDIR"/parameters.json"

STACK_NAME=$(jq -r '.[0].NetworkStackName' "$PARAM_FILE_PATH")

echo "VPN stack name: ${STACK_NAME}"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

if aws cloudformation describe-stacks --stack-name $STACK_NAME &> /dev/null; then
    echo "Stack $STACK_NAME already exists"
    exit 1
fi

##Creating Stack
aws cloudformation create-stack --stack-name "$STACK_NAME" --template-body file://csye6225-cf-networking.json --parameters ParameterKey=StackName,ParameterValue=$STACK_NAME
echo "Creation in progress.."

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

if [ $? -ne 0 ];
then
	echo "Stack $STACK_NAME creation failed!"
    exit 1
fi

echo "stack $STACK_NAME is created successfully!"
