## Getting started

Clone the repository on your local machine

### Stack workflow
#### Stack/Network creation

* To create the stack, run the following script in terminal
```
./csye6225-aws-networking-setup.sh
```
* Enter the name of the region name, tage name, details of CIDR blocks for VPC and subnets to be created. Here's a sample input:
```
Please enter the REGION : us-east-1
Please enter the TAG NAME for resources : csye6225
Please enter the VPC CIDR : 10.0.0.0/16
Please enter subnet 1 : 10.0.1.0/24
Please enter subnet 2 : 10.0.2.0/24
Please enter subnet 3 : 10.0.3.0/24
Please enter port 22 CIDR : 0.0.0.0/0
Please enter port 80 CIDR : 0.0.0.0/0
```

##### Store the VPCID, SubnetIDs, IG ID and RouteTable ID.

#### Stack/Network teardown
* To delete the stack, run the following script in same directory as of create stack in terminal
```
./csye6225-aws-networking-teardown.sh
```
* Enter the stored information generated from the create script.
