## Getting Started

Clone the repository on your local machine

### Stack workflow
#### Stack creation

1. First create networking stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-create-stack.sh <STACK_NAME>
	```
2. Then create policies stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-create-cicd-stack.sh
	```	
3. Then create application stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-create-application-stack.sh
	```	


#### Stack deletion
1. To delete networking stack:
    - Run the following script in terminal
	```
	./csye6225-aws-cf-terminate-stack.sh <STACK_NAME>
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