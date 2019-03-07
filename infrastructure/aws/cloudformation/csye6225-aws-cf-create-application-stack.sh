#!/bin/bash

stack_name=$(jq -r '.[0].VPCStackName' parameters.json)
nw_stack_name=$(jq -r '.[0].NetworkStackName' parameters.json)
key_name=$(jq -r '.[0].EC2_Key' parameters.json)


echo "VPC Stack name: ${stack_name}"
echo "Network stack name: ${nw_stack_name}"
echo "Ec2 key name: ${key_name}"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

step="Fetch: AMI ID"

tag_name="csye6225"

ami_id=$(aws ec2 describe-images \
--filters Name=tag:Name,Values=$tag_name \
--query "reverse(sort_by(Images, &CreationDate))[0].ImageId" \
--output text)

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

aws cloudformation create-stack --stack-name ${stack_name} \
--template-body file://csye6225-cf-application.json \
--parameters ParameterKey=NetworkStackNameParameter,ParameterValue=${nw_stack_name} \
ParameterKey=MyIp,ParameterValue=$finalMyIp \
ParameterKey=AMIid,ParameterValue=${ami_id} \
ParameterKey=StackName,ParameterValue=${stack_name} \
ParameterKey=KeyName,ParameterValue=${key_name}

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
