#!/bin/bash

vpcid=$(echo $VpcId)
subnetId1=$1
subnetId2=$2
subnetId3=$3
publicRouteTableId=$4
internetGatewayId=$5

#deleting all subnets
echo "Deleting all subnets..."
aws ec2 delete-subnet --subnet-id $subnetId1
aws ec2 delete-subnet --subnet-id $subnetId2
aws ec2 delete-subnet --subnet-id $subnetId3
echo "Deleted all subnets"

#deleting public route table
echo "Deleting Public Route Table...."
aws ec2 delete-route-table --route-table-id $publicRouteTableId
if [ $? -ne 0 ]; then
	echo "Failed during deleting the public route table"
	exit 1
else
	echo "Deleted public route table"
fi

#detach internet gateway
echo "Detaching internet gateway....."
aws ec2 detach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcid
if [ $? -ne 0 ]; then
	echo "Failed during detaching the internet gateway from VPC"
	exit 1
else
	echo "Detached internet gateway"
fi

#deleting internet gateway
echo "Deleting internet gateway......."
aws ec2 delete-internet-gateway --internet-gateway-id $internetGatewayId
if [ $? -ne 0]; then
	echo "Failed to delete internet gateway"
	exit 1
else
	echo "Deleted internet gateway"
fi

#deleteing vpc
echo "Deleting VPC....."
aws ec2 delete-vpc --vpc-id $vpcid
if [ $? -ne 0 ]; then
	"Failed during deleteing VPC"
	exit 1
else 
	echo "Deleted VPC!"
fi

echo "======== Networking stack cleared ========="
