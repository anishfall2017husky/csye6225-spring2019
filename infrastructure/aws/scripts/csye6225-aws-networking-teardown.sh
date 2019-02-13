
#!/bin/bash

# ************* Script to create AWS resources using awscli *********************************
# Input Parameters:
#
#  			     tag_name   --   Tag Name    
#
# Change Log:
#
# Feb 05 2019 -- Nilank Sharma  -- Initial Creation
# Feb 06 2019 -- Srikant Swamy  -- Modified
# Feb 12 2019 -- Srikant Swamy  -- Modified inputs to delete resources based on tag name
#
# ********************************************************************************************

echo "Please enter tag name of vpc to delete:"
read tag_name

echo -e "\n"
echo " ************************************************** "
echo " ********** Networking teardown started *********** "
echo " ************************************************** "
echo -e "\n"

echo " ********* Fetching VPC ID *********** "

step="Fetch: VPC ID"

vpc_id=$(aws ec2 describe-vpcs \
--filters Name=tag:Name,Values=$tag_name \
--query 'Vpcs[0].VpcId' --output text)

flag=$?

if [ -z  "$vpc_id" ] || [ "$vpc_id" = "None" ]
then

flag=1

fi

if [ $flag -ne 0 ]
then
	
	echo -e "\n"
	echo " **************************************************** "
	echo " **** Exiting: Failed at - $step with exit status: $flag  **** "
	echo " **************************************************** "
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
	
fi

echo " ******* VPC ID Lookup Complete ******* "

echo " ******** Fetching Subnet Ids *********** "

step="Fetch: Subnet Id for the VPC TAG"

subnet_ids=$(aws ec2 describe-subnets \
--filters Name=vpc-id,Values=$vpc_id \
--query 'Subnets[].SubnetId' --output text)

flag=$?

if [ -z  "$subnet_ids" ] || [ "$subnet_ids" = "None" ]
then

flag=1

fi

if [ $flag -ne 0 ]
then
	echo -e "\n"
	echo " **************************************************** "
	echo " **** Exiting: Failed at - $step with exit status: $flag *** "
	echo " **************************************************** "
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
fi

echo " ******* Fetch Subnet Complete ******* "

# Deleting Subnets

echo " ****** Deleting Subnets ******* "

step="Delete: Subnet"

for subnet_id in ${subnet_ids}; do
	aws ec2 delete-subnet --subnet-id $subnet_id

	flag=$?

	if [ $flag -ne 0 ]; then
	
		echo -e "\n"
		echo " **************************************************** "
		echo " **** Exiting: Failed at - $step with exit status: $flag **** "
		echo " **************************************************** "
		echo " ************ Teardown Process Complete ************* "
		echo -e "\n"
		exit 1
	else
		echo " ******* SUBNET: ${subnet_id} deleted ******** "
	fi
done


# Deleting public route table

step="Fetch: Public Route Table"

echo " **** Fetching Public Route Table **** "

route_table_ids=$(aws ec2 describe-route-tables \
--filters Name=vpc-id,Values=$vpc_id Name=tag:Name,Values=$tag_name \
--query 'RouteTables[].RouteTableId' --output text)

flag=$?

if [ -z  "$route_table_ids" ] || [ "$route_table_ids" = "None" ]
then

flag=1

fi

if [ $flag -ne 0 ]
then
	
	echo -e "\n"
	echo " **************************************************** "
	echo " **** Exiting: Failed at - $step with exit status: $flag **** "
	echo " **************************************************** "
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
fi

echo " ******* Fetch Route Table Complete ******* "

step="Delete: Public Route Table"

echo " **** Deleting Route Table ************* "

for route_table_id in ${route_table_ids}; do
	aws ec2 delete-route-table --route-table-id $route_table_id

	flag=$?

	if [ $flag -ne 0 ]; then
	
		echo -e "\n"
		echo " **************************************************** "
		echo " **** Exiting: Failed at - $step with exit status: $flag **** "
		echo " **************************************************** "
		echo " ************ Teardown Process Complete ************* "
		echo -e "\n"
		exit 1
	else
		echo " ******* Route Table ID: ${route_table_id} deleted ******** "
	fi
done

flag=$?


# Detach Internet Gateway

step="Fetch: Internet Gateway"

echo " ******** Fetching Internet Gateway ******** "

igw_ids=$(aws ec2 describe-internet-gateways \
--filter Name=attachment.vpc-id,Values=$vpc_id \
--query InternetGateways[].InternetGatewayId --output text)

flag=$?

if [ -z  "$igw_ids" ] || [ "$igw_ids" = "None" ]
then

flag=1

fi

if [ $flag -ne 0 ]
then
	
	echo -e "\n"
	echo " **************************************************** "
	echo " **** Exiting: Failed at - $step with exit status: $flag **** "
	echo " **************************************************** "
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
fi

step="Detach: Internet Gateway"

echo " ******** Detaching Internet Gateway ******** "

for igw_id in ${igw_ids}; do
	aws ec2 detach-internet-gateway --internet-gateway-id $igw_id --vpc-id $vpc_id
	
	flag=$?

	if [ $flag -ne 0 ]; then
	
		echo -e "\n"
		echo " **************************************************** "
		echo " **** Exiting: Failed at - $step with exit status: $flag **** "
		echo " **************************************************** "
		echo " ************ Teardown Process Complete ************* "
		echo -e "\n"
		exit 1
	else
		echo " ******* Internet Gateway ID: ${igw_id} detached ******** "
	fi
done


# Deleting Internet gateway

step="Delete: Internet Gateway"

echo " ****** Deleting Internet Gateway ****** "

for igw_id in ${igw_ids}; do
	aws ec2 delete-internet-gateway --internet-gateway-id $igw_id

	flag=$?
	
	if [ $flag -ne 0 ]; then
	
		echo -e "\n"
		echo " **************************************************** "
		echo " **** Exiting: Failed at - $step with exit status: $flag **** "
		echo " **************************************************** "
		echo " ************ Teardown Process Complete ************* "
		echo -e "\n"
		exit 1
	else
		echo " ******* Internet Gateway ID: ${igw_id} deleted ******** "
	fi	
done


# Deleting VPC

step="Delete: VPC"

echo " ******* Deleting VPC ******** "

aws ec2 delete-vpc --vpc-id $vpc_id

flag=$?

if [ $flag -ne 0 ]
then
	
	echo -e "\n"
	echo " **************************************************** "
	echo " **** Exiting: Failed at - $step with exit status: $flag **** "
	echo " **************************************************** "
	echo " ************ Teardown Process Complete ************* "
	echo -e "\n"
	exit 1
else 
	echo " ***** VPC: $vpc_id Deleted ******* "
fi

echo -e "\n"

echo " ************** All Resources Deleted ************** "
echo " *************************************************** "
echo " ********** Networking teardown completed ********** "
echo " *************************************************** "


