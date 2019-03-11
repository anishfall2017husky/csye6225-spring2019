#!/bin/bash

echo "Please enter EC2 stack name: "
read stack_name

echo "Please enter network stack name: "
read nw_stack_name

echo "Please enter policies stack name: "
read policies_stack_name

echo "Please enter ec2 key name: "
read key_name

step="Fetch: AMI ID"

tag_name="csye6225"

ami_id=$(aws ec2 describe-images --filters Name=tag:Name,Values=$tag_name --query 'Images[0].ImageId' --output text)

flag=$?

if [ -z  "$ami_id" ] || [ "$ami_id" = "None" ]
then

flag=1

fi

if [ $flag -ne 0 ]
then

	echo -e "\n"
	echo " **************************************************** "
	echo " **** Exiting: Failed at - $step with exit status: $flag **** "
	echo " **************************************************** "
	echo " ************ Create Application Process Complete ************* "
	echo -e "\n"
	exit 1
fi




echo "Executing Create Stack....."

aws cloudformation create-stack --stack-name ${stack_name} --template-body file://csye6225-cf-application.json --parameters ParameterKey=NetworkStackNameParameter,ParameterValue=${nw_stack_name} \
ParameterKey=AMIid,ParameterValue=${ami_id} ParameterKey=StackName,ParameterValue=${stack_name} ParameterKey=IAMPolicyStackNameParameter,ParameterValue=${policies_stack_name} \
ParameterKey=KeyName,ParameterValue=${key_name} \
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
