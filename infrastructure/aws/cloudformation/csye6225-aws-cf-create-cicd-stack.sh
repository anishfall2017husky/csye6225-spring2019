#!/bin/bash

CICD_STACK_NAME=$(jq -r '.[0].cicd_stack' parameters.json)

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
APPLICATION_NAME=$(jq -r '.[0].webapp_name' parameters.json)
AWS_REGION=$(jq -r '.[0].aws_region' parameters.json)
CD_BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[*].[Name]" --output text | awk '/code-deploy./{print}')
DYNAMODB_TABLE=$(jq -r '.[0].dynamodb_table' parameters.json)
LAMBDA_FUNCTION_NAME=$(jq -r '.[0].lambda_function' parameters.json)

echo "AWS region: ${AWS_REGION}"
echo "Webapp Name: ${APPLICATION_NAME}"
echo "Code deploy Bucket Name: ${CD_BUCKET_NAME}"
echo "Circleci stack: ${CICD_STACK_NAME}"
echo "DynamoDB table name: ${DYNAMODB_TABLE}"
echo "Lambda function name: ${LAMBDA_FUNCTION_NAME}"

read -p "Continue?(Y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

echo "Creating stack..."

aws cloudformation create-stack --stack-name ${CICD_STACK_NAME} \
--template-body file://csye6225-cf-cicd-stack.yml \
--parameters ParameterKey=AwsAccountID,ParameterValue=${AWS_ACCOUNT_ID} \
ParameterKey=ApplicationName,ParameterValue=${APPLICATION_NAME} \
ParameterKey=AwsRegion,ParameterValue=${AWS_REGION} \
ParameterKey=CDBucketName,ParameterValue=${CD_BUCKET_NAME} \
ParameterKey=DynamoDBTable,ParameterValue=${DYNAMODB_TABLE} \
ParameterKey=LambdaFunctionName,ParameterValue=${LAMBDA_FUNCTION_NAME} \
--capabilities CAPABILITY_NAMED_IAM

if [ $? -eq 0 ]; then
	echo "Waiting to creating stack completely...!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi

aws cloudformation wait stack-create-complete --stack-name ${CICD_STACK_NAME}

if [ $? -eq 0 ]; then
	echo "Stack successfully created...!"
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi
