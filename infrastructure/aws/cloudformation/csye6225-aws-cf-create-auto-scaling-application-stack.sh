#!/bin/bash

BASEDIR=$(dirname "$0")
PARAM_FILE_PATH=$BASEDIR"/parameters.json"

stack_name=$(jq -r '.[0].StackName' "$PARAM_FILE_PATH")
nw_stack_name=$(jq -r '.[0].NetworkStackName' "$PARAM_FILE_PATH")
key_name=$(jq -r '.[0].EC2_Key' "$PARAM_FILE_PATH")
waf_stackName=$(jq -r '.[0].WafStackName' "$PARAM_FILE_PATH")

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
APPLICATION_NAME=$(jq -r '.[0].webapp_name' "$PARAM_FILE_PATH")
AWS_REGION=$(jq -r '.[0].aws_region' "$PARAM_FILE_PATH")
CD_BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[*].[Name]" --output text | awk '/code-deploy./{print}')
ATTACHMENTS_BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[*].[Name]" --output text | awk '/csye6225.com$/{print}')
DOMAIN_NAME=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)
NOWAF_DOMAIN_NAME=nowaf."${DOMAIN_NAME}"

FUNCTION=$(jq -r '.[0].lambda_function' "$PARAM_FILE_PATH")
LAMBDA_ROLE=$(aws iam get-role --role-name LambdaExecutionRole --query Role.Arn --output text)

SNS_TOPIC="arn:aws:sns:us-east-1:"$AWS_ACCOUNT_ID":password_reset"
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=false" --query "Vpcs[*].VpcId" --output text)

SUBNET_A=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${VPC_ID}" "Name=mapPublicIpOnLaunch,Values=true" "Name=availabilityZone,Values=us-east-1a" --query 'Subnets[*].SubnetId'  --output text)
SUBNET_B=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${VPC_ID}" "Name=mapPublicIpOnLaunch,Values=true" "Name=availabilityZone,Values=us-east-1b" --query 'Subnets[*].SubnetId'  --output text)
CERTIFICATE_ARN=$(aws acm list-certificates --query "CertificateSummaryList[0].CertificateArn" --output text)
CERTIFICATE_ARN2=$(aws acm list-certificates --query "CertificateSummaryList[1].CertificateArn" --output text)


echo "Stack name: ${stack_name}"
echo "VPN stack name: ${nw_stack_name}"
echo "WAF stack name: ${waf_stackName}"
echo "EC2 key name: ${key_name}"
echo "AWS region: ${AWS_REGION}"
echo "Webapp Name: ${APPLICATION_NAME}"
echo "Code deploy Bucket Name: ${CD_BUCKET_NAME}"
echo "Attachments Bucket Name: ${ATTACHMENTS_BUCKET_NAME}"
echo "Lambda Function Name: ${FUNCTION}"
echo "Domain Name: ${DOMAIN_NAME}"
echo "Nowaf subdomain name: ${NOWAF_DOMAIN_NAME}"
echo "Subnet for region us-east-1a: ${SUBNET_A}"
echo "Subnet for region us-east-1b: ${SUBNET_B}"
echo "Certificate ARN: ${CERTIFICATE_ARN}"
echo "Certificate ARN: ${CERTIFICATE_ARN2}"
echo "VPC ID: ${VPC_ID}"

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
--template-body file://csye6225-cf-auto-scaling-application.json \
--parameters ParameterKey=NetworkStackNameParameter,ParameterValue=${nw_stack_name} \
ParameterKey=AMIid,ParameterValue=${ami_id} \
ParameterKey=StackName,ParameterValue=${stack_name} \
ParameterKey=KeyName,ParameterValue=${key_name} \
ParameterKey=AwsAccountID,ParameterValue=${AWS_ACCOUNT_ID} \
ParameterKey=ApplicationName,ParameterValue=${APPLICATION_NAME} \
ParameterKey=AwsRegion,ParameterValue=${AWS_REGION} \
ParameterKey=CDBucketName,ParameterValue=${CD_BUCKET_NAME} \
ParameterKey=AttachmentsBucketName,ParameterValue=${ATTACHMENTS_BUCKET_NAME} \
ParameterKey=FunctionName,ParameterValue=${FUNCTION} \
ParameterKey=LambdaRole,ParameterValue=${LAMBDA_ROLE} \
ParameterKey=DomainName,ParameterValue=${DOMAIN_NAME} \
ParameterKey=SNSTopic,ParameterValue=${SNS_TOPIC} \
ParameterKey=SubnetA,ParameterValue=${SUBNET_A} \
ParameterKey=SubnetB,ParameterValue=${SUBNET_B} \
ParameterKey=CertificateArn,ParameterValue=${CERTIFICATE_ARN} \
ParameterKey=VpcId,ParameterValue=${VPC_ID} \
ParameterKey=WafStackName,ParameterValue=${waf_stackName} \
ParameterKey=NowafDomainName,ParameterValue=${NOWAF_DOMAIN_NAME} \
ParameterKey=CertificateArn2,ParameterValue=${CERTIFICATE_ARN2} \
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
else
	echo "Error in creating Stack...Exiting..."
	exit 1
fi
