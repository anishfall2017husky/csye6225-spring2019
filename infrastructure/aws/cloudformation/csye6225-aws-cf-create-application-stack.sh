#!/bin/bash

echo "Please enter stack name: "
read stack_name

echo "Please enter network stack name: "
read nw_stack_name

myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
finalMyIp=$myip/32
echo $myip
echo $finalMyIp


echo "Executing Create Stack....."

aws cloudformation create-stack --stack-name ${stack_name} --template-body file://csye6225-cf-application.json --parameters ParameterKey=NetworkStackNameParameter,ParameterValue=${nw_stack_name} ParameterKey=MyIp,ParameterValue=$finalMyIp

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
