#!/bin/bash

echo "Please enter IAM Policies stack name: "
read stack_name

echo "Executing Create Stack....."

aws cloudformation create-stack --stack-name ${stack_name} --template-body file://csye6225-cf-policies.json --parameters ParameterKey=StackName,ParameterValue=${stack_name} \
--capabilities=CAPABILITY_NAMED_IAM

if [ $? -eq 0 ]; then
	echo "Waiting to creating stack completely...!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi

aws cloudformation wait stack-create-complete --stack-name ${stack_name}

if [ $? -eq 0 ]; then
	echo "Stack successfully created...!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi

echo "Stack successfully created...!"
