#!/bin/bash

BASEDIR=$(dirname "$0")
PARAM_FILE_PATH=$BASEDIR"/parameters.json"

STACK_NAME=$(jq -r '.[0].StackName' "$PARAM_FILE_PATH")

echo "Auto-scaling stack name: ${STACK_NAME}"

read -p "Continue?(Y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

echo "Deleting Stack: $STACK_NAME"
aws cloudformation delete-stack --stack-name ${STACK_NAME} 

aws cloudformation wait stack-delete-complete --stack-name ${STACK_NAME}
echo "Stack successfully deleted...!"