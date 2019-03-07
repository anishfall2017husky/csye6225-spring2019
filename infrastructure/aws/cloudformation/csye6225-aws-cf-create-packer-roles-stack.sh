#!/bin/bash

circleci_pstack=$(jq -r '.[0].circleci_pstack' parameters.json)

echo "Circleci packer roles stack: ${circleci_pstack}"

read -p "Continue?(Y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

echo "Creating stack..."

aws cloudformation create-stack --stack-name ${circleci_pstack} \
--template-body file://csye6225-cf-cicd-packer.yml \
--capabilities CAPABILITY_NAMED_IAM

if [ $? -eq 0 ]; then
	echo "Waiting to creating stack completely...!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi

aws cloudformation wait stack-create-complete --stack-name ${circleci_pstack}

if [ $? -eq 0 ]; then
	echo "Stack successfully created...!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi
