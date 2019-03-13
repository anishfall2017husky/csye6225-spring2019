#!/bin/bash

stack_name=$(jq -r '.[0].StackName' parameters.json)
nw_stack_name=$(jq -r '.[0].NetworkStackName' parameters.json)
key_name=$(jq -r '.[0].EC2_Key' parameters.json)

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
APPLICATION_NAME=$(jq -r '.[0].webapp_name' parameters.json)
AWS_REGION=$(jq -r '.[0].aws_region' parameters.json)
CD_BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[*].[Name]" --output text | awk '/code-deploy./{print}')
ATTACHMENTS_BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[*].[Name]" --output text | awk '/csye6225.com$/{print}')

echo "Stack name: ${stack_name}"
echo "VPN stack name: ${nw_stack_name}"
echo "EC2 key name: ${key_name}"
echo "AWS region: ${AWS_REGION}"
echo "Webapp Name: ${APPLICATION_NAME}"
echo "Code deploy Bucket Name: ${CD_BUCKET_NAME}"
echo "Attachments Bucket Name: ${ATTACHMENTS_BUCKET_NAME}"

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
ParameterKey=AMIid,ParameterValue=${ami_id} \
ParameterKey=StackName,ParameterValue=${stack_name} \
ParameterKey=KeyName,ParameterValue=${key_name} \
ParameterKey=AwsAccountID,ParameterValue=${AWS_ACCOUNT_ID} \
ParameterKey=ApplicationName,ParameterValue=${APPLICATION_NAME} \
ParameterKey=AwsRegion,ParameterValue=${AWS_REGION} \
ParameterKey=CDBucketName,ParameterValue=${CD_BUCKET_NAME} \
ParameterKey=AttachmentsBucketName,ParameterValue=${ATTACHMENTS_BUCKET_NAME} \
--capabilities CAPABILITY_NAMED_IAM

if [ $? -eq 0 ]; then
	echo "Waiting to creating stack completely...!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi

aws cloudformation wait stack-create-complete --stack-name ${stack_name}

if [ $? -eq 0 ]; then
	echo "Stack successfully created...!"
	USER_NAME=$(jq -r '.[1].CircleCIUserName' parameters.json)
	BRANCH=$(jq -r '.[1].Branch' parameters.json)
	read -p "Enter circleci token (Leave blank to not deploy app): " CIRCLECI_USER_TOKEN
	if [ -z $CIRCLECI_USER_TOKEN ]
	then
			curl -u ${CIRCLECI_USER_TOKEN}: \
			-d build_parameters[CIRCLE_JOB]=build-app \
			https://circleci.com/api/v1.1/project/github/${USER_NAME}/csye6225-spring2019/tree/${BRANCH}
	else
		echo "App not deployed on EC2!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi

aws cloudformation wait stack-create-complete --stack-name ${stack_name}

if [ $? -eq 0 ]; then
	echo "Stack successfully created...!"
	USER_NAME=$(jq -r '.[1].CircleCIUserName' parameters.json)
	BRANCH=$(jq -r '.[1].Branch' parameters.json)
	read -p "Enter circleci token (Leave blank to not deploy app): " CIRCLECI_USER_TOKEN
	if [ -z $CIRCLECI_USER_TOKEN ] 
	then
		curl -u ${CIRCLECI_USER_TOKEN}: \
    	-d build_parameters[CIRCLE_JOB]=build-app \
		https://circleci.com/api/v1.1/project/github/${USER_NAME}/csye6225-spring2019/tree/${BRANCH}
	else 
		echo "App not deployed on EC2!"
	fi
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi
