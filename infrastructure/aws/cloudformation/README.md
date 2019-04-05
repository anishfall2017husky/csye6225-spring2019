## Getting Started

Clone the repository on your local machine  
All the parameter values are stored from <strong>parameters.json</strong>

### Stack workflow
#### Stack creation

1. First create networking stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-create-stack.sh
	```
2. Then create policies stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-create-cicd-stack.sh
	```	
3. Then create application stack:
    - For not auto-scaling instance run the following script in terminal
	```
	./csye6225-aws-cf-create-application-stack.sh
	```	
	- For auto-scaling instances run the following script in terminal
	```
	./csye6225-aws-cf-create-auto-scaling-application-stack.sh
	```	


#### Stack deletion
1. To delete networking stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-terminate-stack.sh
	```
	
2. To delete application stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-terminate-application-stack.sh
	```	
3. To delete policies stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-terminate-cicd-stack.sh
	```	