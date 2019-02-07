#!/bin/bash

# ************* Script to create AWS resources using awscli *********************************
#
#     region_name        --   AWS Region Name     
#     tag_name 	         --   Tag prefix for AWS resources
#     vpc_cidr           --   CIDR block for VPC
#     subnet_1_cidr      --   CIDR block for Subnet 1
#     subnet_2_cidr      --   CIDR block for Subnet 2
#     subnet_3_cidr      --   CIDR block for subnet 3
#     port_22_cidr       --   Port 22 CIDR block for default security group
#     port_80_cidr       --   Port 80 CIDR block for default security group
#
#
# Change Log:
#
# Feb 5 2019 -- Srikant Swamy -- Initial Creation
#
# ********************************************************************************************


echo "Param-1: Please enter REGION NAME:"
read region_name

echo "Please enter TAG NAME:"
read tag_name

echo "Please enter VPC CIDR:"
read vpc_cidr

echo "Please enter SUBNET-1 CIDR:"
read subnet_1_cidr

echo "Please enter SUBNET-2 CIDR:"
read subnet_2_cidr

echo "Please enter SUBNET-3 CIDR:"
read subnet_3_cidr

echo "Please enter PORT22 CIDR:"
read port22_cidr_block

echo "Please enter PORT80 CIDR:"
read port80_cidr_block


#region_name=$1
#tag_name=$2
#vpc_cidr=$3
#subnet_1_cidr=$4
#subnet_2_cidr=$5
#subnet_3_cidr=$6
#port22_cidr_block=$7
#port80_cidr_block=$8

vpc_name="$tag_name"-vpc
subnet_name="$tag_name"-subnet
internet_gateway_name="$tag_name"-IG
route_table_name="$tag_name"-RT

az_1="$region_name"a
az_2="$region_name"b
az_3="$region_name"c

step="START"

echo " *********************************************** "
echo " ************* Script Started ****************** "
echo " *********************************************** "


subnet_name_1=${subnet_name}_${az_1}
subnet_name_2=${subnet_name}_${az_2}
subnet_name_3=${subnet_name}_${az_3}

step="Create vpc"

echo " ****** Creating VPC ****** "

vpc_id=$(aws ec2 create-vpc \
 --cidr-block $vpc_cidr \
 --query 'Vpc.{VpcId:VpcId}' \
 --output text \
 --region $region_name)

flag=$?


if [ $flag -eq 0 ] 
then
	step="Create tag for vpc"

	echo " VPC ID '$vpc_id' CREATED in '$region_name' region."
	
	

	aws ec2 create-tags \
	 --resources $vpc_id \
	 --tags "Key=Name,Value=$vpc_name" \
	 --region $region_name

	flag=$? 

fi
	


if [ $flag -eq 0 ] 
then
	step="Create subnet-1"

	echo " VPC ID '$vpc_id' NAMED as '$vpc_name'."

	echo " ****** Tag $vpc_name added to VPC ****** "	

	echo " ****** Creating Subnet-1 ******"

	subnet_id_1=$(aws ec2 create-subnet \
	 --vpc-id $vpc_id \
	 --cidr-block $subnet_1_cidr \
	 --availability-zone $az_1 \
	 --query 'Subnet.{SubnetId:SubnetId}' \
	 --output text \
	 --region $region_name)

	flag=$?

	
fi




if [ $flag -eq 0 ] 
then
	step="Create tag subnet-1"

	echo "  Subnet ID '$subnet_id_1' CREATED in '$az_1'" \
	"Availability Zone."


	
	aws ec2 create-tags \
	 --resources $subnet_id_1 \
	 --tags "Key=Name,Value=$subnet_name_1" \
	 --region $region_name

	flag=$?


fi



	
if [ $flag -eq 0 ] 
then
	step="Create subnet-2"

	echo "  Subnet ID '$subnet_id_1' NAMED as '$subnet_name_1'."


	

	echo " ****** Creating Subnet-2 ******"
	subnet_id_2=$(aws ec2 create-subnet \
	 --vpc-id $vpc_id \
	 --cidr-block $subnet_2_cidr \
	 --availability-zone $az_2 \
	 --query 'Subnet.{SubnetId:SubnetId}' \
	 --output text \
	 --region $region_name)

	flag=$?


fi




if [ $flag -eq 0 ] 
then
	step="Create tag subnet-2"

	echo "  Subnet ID '$subnet_id_2' CREATED in '$az_2'" \
	"Availability Zone."

	

	aws ec2 create-tags \
	 --resources $subnet_id_2 \
	 --tags "Key=Name,Value=$subnet_name_2" \
	 --region $region_name


	flag=$?



fi


	
if [ $flag -eq 0 ] 
then
	step="Create subnet-3"

	echo "  Subnet ID '$subnet_id_2' NAMED as '$subnet_name_2'."

	

	echo " ****** Creating Subnet-3 ******"
	subnet_id_3=$(aws ec2 create-subnet \
	 --vpc-id $vpc_id \
	 --cidr-block $subnet_3_cidr \
	 --availability-zone $az_3 \
	 --query 'Subnet.{SubnetId:SubnetId}' \
	 --output text \
	 --region $region_name)

	flag=$?


fi





if [ $flag -eq 0 ] 
then
	step="Create tag subnet-3"

	echo "  Subnet ID '$subnet_id_3' CREATED in '$az_3'" \
	"Availability Zone."


	aws ec2 create-tags \
	 --resources $subnet_id_3 \
	 --tags "Key=Name,Value=$subnet_name_3" \
	 --region $region_name

	flag=$?


fi





if [ $flag -eq 0 ] 
then
	step="Create IG"

	echo "  Subnet ID '$subnet_id_3' NAMED as '$subnet_name_3'."


	

	echo " ****** Creating Subnet-1 ******"
	igw_id=$(aws ec2 create-internet-gateway \
	 --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
	 --output text \
	 --region $region_name)

	flag=$?


fi





if [ $flag -eq 0 ] 
then
	step="Attach IG"

	echo "  Internet Gateway ID '$igw_id' CREATED."

	

	aws ec2 attach-internet-gateway \
	 --vpc-id $vpc_id \
	 --internet-gateway-id $igw_id \
	 --region $region_name

	 flag=$?

	
fi



if [ $flag -eq 0 ] 
then
	step="Tag IG"

	echo "  Internet Gateway ID '$igw_id' ATTACHED to VPC ID '$vpc_id'"

	# Tag Internet Gateway
	echo " ****** Tagging Internet Gateway ******"

	aws ec2 create-tags \
	 --resources "$igw_id" \
	 --tags Key=Name,Value="$internet_gateway_name"

	flag=$?


fi





if [ $flag -eq 0 ] 
then
	step="Create RT"

	echo "  IG '$igw_id' NAMED as '$internet_gateway_name'."

	

	echo " ******* Creating Route Table ********"
	route_table_id=$(aws ec2 create-route-table \
	 --vpc-id $vpc_id \
	 --query 'RouteTable.{RouteTableId:RouteTableId}' \
	 --output text \
	 --region $region_name)

	 flag=$?

	
fi  




if [ $flag -eq 0 ] 
then
	step="Tag RT"

	echo "  Route Table ID '$route_table_id' CREATED."

	

	echo " ****** Tagging Route Table ******"

	# Tag Route Table
	aws ec2 create-tags \
	 --resources "$route_table_id" \
	 --tags Key=Name,Value="$route_table_name"

	 flag=$?


fi  



if [ $flag -eq 0 ] 
then
	step="Attach subnet-1 to RT"
	
	echo " ****** Attaching Subnet-1 to Route Table *********"

	# Associate Subnet - 1 with Route Table
	attach_route_table=$(aws ec2 associate-route-table  \
	 --subnet-id $subnet_id_1 \
	 --route-table-id $route_table_id \
	 --region $region_name)

	flag=$?


fi



if [ $flag -eq 0 ] 
then
	step="Attach subnet-2 to RT"

	echo "  Public Subnet ID '$subnet_id_1' ASSOCIATED with Route Table ID" \
	  "'$route_table_id'."

	echo " ****** Attaching Subnet-2 to Route Table *********"

	# Associate Subnet - 2 with Route Table
	attach_route_table=$(aws ec2 associate-route-table  \
	 --subnet-id $subnet_id_2 \
	 --route-table-id $route_table_id \
	 --region $region_name)

	flag=$?


fi	



if [ $flag -eq 0 ] 
then
	step="Attach subnet-3 to RT"

	echo "  Public Subnet ID '$subnet_id_2' ASSOCIATED with Route Table ID" \
	  "'$route_table_id'."

	

	echo " ****** Attaching Subnet-3 to Route Table *********"

	# Associate Subnet - 3 with Route Table
	attach_route_table=$(aws ec2 associate-route-table  \
	 --subnet-id $subnet_id_3 \
	 --route-table-id $route_table_id \
	 --region $region_name)

	flag=$?


fi	



if [ $flag -eq 0 ] 
then
	step="Open RT"

	echo "  Public Subnet ID '$subnet_id_3' ASSOCIATED with Route Table ID" \
	  "'$route_table_id'."

	

	# Open route table

	echo " ****** Opening Route Table *********"

	open_route_table=$(aws ec2 create-route \
	 --route-table-id $route_table_id \
	 --destination-cidr-block 0.0.0.0/0 \
	 --gateway-id $igw_id \
	 --region $region_name)

	 flag=$?


fi	



if [ $flag -eq 0 ] 
then 
	step="Get SG id"

	echo "  Route to '0.0.0.0/0' via Internet Gateway ID '$igw_id' ADDED to" \
	"Route Table ID '$route_table_id'."
	
	echo " ***** Finding Default Security Group ID ***** "
	

	default_sg_id=$(aws ec2 describe-security-groups \
	--filters Name=vpc-id,Values=$vpc_id| \
	jq -r '.SecurityGroups[] | select (.GroupName == "default") | .GroupId')

	flag=$?


fi	



if [ $flag -eq 0 ] 
then
	step="Remove default rule"

	echo " ***** Default Security Group ID: $default_sg_id *****"

	aws ec2 revoke-security-group-ingress \
	 --source-group $default_sg_id \
	 --group-id $default_sg_id \
	 --protocol "all" --port "all"

	flag=$?


fi




if [ $flag -eq 0 ] 
then
	step="Add P22 rule"

	
	echo " **** Default Security Group rule removed from SG: $default_sg_id **** "

	add_ssh=$(aws ec2 authorize-security-group-ingress \
	 --group-id "$default_sg_id" \
	 --protocol tcp --port 22 \
	 --cidr "$port22_cidr_block")

	 flag=$?


fi




if [ $flag -eq 0 ] 
then
	step="Add P80 rule"

	
	echo " ******* Rule for Port 22 added in SG: $default_sg_id ******* "

	add_tcp=$(aws ec2 authorize-security-group-ingress \
	 --group-id "$default_sg_id" \
	 --protocol tcp --port 80 \
	 --cidr "$port22_cidr_block")

	flag=$?


fi


if [ $flag -eq 0 ] 
then

	echo " ****** Rule for Port 80 added in SG: $default_sg_id ***** "
	echo " ********* All resources created ***********"

	flag=0

	echo -e "\n"

	echo " ***************************************************************************** "
	echo " ******* Script eneded successfully. Exit status: $flag ********************** "
	echo " ***************************************************************************** "

	echo -e "\n"

	exit 0

else
	flag=1

	echo -e "\n"

	echo " ******************************************************************************* "
	echo " ******** Script ended with failure - Step: $step - Exit status: $flag ********* "
	echo " ******************************************************************************* "
	
	echo -e "\n"
	
	exit 1
fi

