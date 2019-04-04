#!/bin/bash

BASEDIR=$(dirname "$0")
PARAM_FILE_PATH=$BASEDIR"/parameters.json"

STACK_NAME=$(jq -r '.[0].NetworkStackName' "$PARAM_FILE_PATH")

echo "VPN stack name: ${STACK_NAME}"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

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
