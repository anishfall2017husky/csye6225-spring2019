
#!/bin/bash

# ************* Script to create AWS resources using awscli *********************************
#
#     vpc_id               --   VPC ID     
#     subnetid1 	       --   Subnet ID-1
#     subnetid2            --   Subnet ID-2
#     subnetid3            --   Subnet ID-3
#     publicRouteTableId   --   Public Route Table ID
#     internetGatewayId    --   Internet Gateway ID
#
# Change Log:
#
# Feb 5 2019 -- Nilank Sharma  -- Initial Creation
# Feb 6 2019 -- Srikant Swamy  -- Modified
#
# ********************************************************************************************

echo "Please enter SUBNET-1 ID:"
read subnetId1

echo "Please enter SUBNET-2 ID:"
read subnetId2

echo "Please enter SUBNET-3 ID:"
read subnetId3

echo "Please enter INTERNET GATEWAY ID:"
read internetGatewayId

echo "Please enter PUBLIC ROUTE TABLE ID:"
read publicRouteTableId

echo "Please enter VPC ID:"
read vpcid

#vpcid=$(echo $VpcId)
#subnetId1=$1
#subnetId2=$2
#subnetId3=$3
#publicRouteTableId=$4
#internetGatewayId=$5

echo -e "\n"
echo " ************************************************** "
echo " ********** Networking teardown started *********** "
echo " ************************************************** "
echo -e "\n"



# Deleting Subnets

echo " ****** Deleting Subnets ******* "

echo " ****** Deleting Subnet-1 ****** "

step="Deletion: Subnet 1"

aws ec2 delete-subnet --subnet-id $subnetId1

flag=$?

if [ $flag -ne 0 ]; then
	flag=1
	echo -e "\n"
	echo " **************************************************** "
	echo "Exiting: Failed at step: $step with exit status: $flag"
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else
	echo " ******* Deleted Subnet $subnetId1 ******* "
fi

step="Deletion: Subnet 2"

echo " ****** Deleting Subnet-2 ****** "
aws ec2 delete-subnet --subnet-id $subnetId2

flag=$?

if [ $flag -ne 0 ]; then
	flag=1
	echo -e "\n"
	echo " **************************************************** "
	echo "Exiting: Failed at step: $step with exit status: $flag"
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else
	echo " ******* Deleted Subnet $subnetId2 ******* "
fi

step="Deletion: Subnet 3"

echo " ****** Deleting Subnet-3 ****** "
aws ec2 delete-subnet --subnet-id $subnetId3

flag=$?

if [ $flag -ne 0 ]; then
	flag=1
	echo -e "\n"
	echo " **************************************************** "
	echo "Exiting: Failed at step: $step with exit status: $flag"
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else
	echo " ******* Deleted Subnet $subnetId3 ******* "
fi


echo " ****** Deleted Subnets ******** "

#Deleting public route table

step="Deletion: Public Route Table"

echo " **** Deleting Public Route Table **** "

aws ec2 delete-route-table --route-table-id $publicRouteTableId

flag=$?

if [ $flag -ne 0 ]; then
	flag=1
	echo -e "\n"
	echo " **************************************************** "
	echo "Exiting: Failed at step: $step with exit status: $flag"
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else
	echo " ******* Deleted public route table $publicRouteTableId ******* "
fi

# Detach Internet Gateway

step="Detach: Internet Gateway"

echo " ******** Detaching Internet Gateway ******** "

aws ec2 detach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcid

flag=$?

if [ $flag -ne 0 ]; then
	flag=1
	echo -e "\n"
	echo " **************************************************** "
	echo "Exiting: Failed at step: $step with exit status: $flag"
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else
	echo " ****** Detached internet gateway $internetGatewayId ****** "
fi

# Deleting Internet gateway

step="Deletion: Internet Gateway"

echo " ****** Deleting Internet Gateway ****** "

aws ec2 delete-internet-gateway --internet-gateway-id $internetGatewayId

flag=$?

if [ $flag -ne 0]; then
	flag=1
	echo -e "\n"
	echo " **************************************************** "
	echo "Exiting: Failed at step: $step with exit status: $flag"
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else
	echo " ****** Deleted Internet Gateway $internetGatewayId ****** "
fi

# Deleteing VPC

step="Deletion: VPC"

echo " ******* Deleting VPC ******** "

aws ec2 delete-vpc --vpc-id $vpcid

flag=$?

if [ $flag -ne 0 ]; then
	flag=1
	echo -e "\n"
	echo " **************************************************** "
	echo "Exiting: Failed at step: $step with exit status: $flag"
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else 
	echo " ***** VPC $vpcid Deleted ******* "
fi

echo -e "\n"

echo " ************** All resources deleted ************** "
echo " *************************************************** "
echo " ********** Networking teardown completed ********** "
echo " *************************************************** "


