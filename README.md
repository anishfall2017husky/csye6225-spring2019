# CSYE 6225 - Spring 2019

## Team Information

| Name | NEU ID | Email Address |
| --- | --- | --- |
| Abhinn Ankit | 001837913 | ankit.a@husky.neu.edu |
| Anish Surti | 001814243 | surti.a@husky.neu.edu |
| Srikant Swamy | 001212307 | swamy.sr@husky.neu.edu |
| Nilank Sharma | 001279669 | sharma.nil@husky.neu.edu |

## Technology Stack
### 1. Operating System
* Linux based Operating System - Ubuntu
### 2. Programming Language
* Java 8
### 3. Relational Database
* MySQL
### 4. Backend
* Spring Boot
* Maven
### 5. Testing
* JUnit
* Mockito
* REST-assured



## Build Instructions
  
### Start mysql server
`systemctl start mysql`

### Start the backend server
Navigate to webapp folder  
`cd webapp`<br><br>
Run the following command

### For Default profile
`./mvnw spring-boot:run -Dspring-boot.run.profiles=default -Dspring-boot.run.arguments=--spring.bucket.name=*bucket-name*`

### For Dev profile
`./mvnw spring-boot:run -Dspring-boot.run.profiles=dev -Dspring-boot.run.arguments=--spring.bucket.name=*bucket-name*,--spring.datasource.url=jdbc:mysql://*endpoint-url*/csye6225`

## Deploy Instructions

### Technology
* AWS CodeDeploy

### Usage
* Need to create an aws codedeploy application
* Run the following command in order

`aws deploy push --application-name <code_deploy_app_name> --s3-location s3://<bucket_name>/csye6225-webapp-<build_num>.zip --ignore-hidden-files`

`aws deploy create-deployment --application-name <code_deploy_app_name> --deployment-config-name CodeDeployDefault.OneAtATime  --deployment-group-name <deployment_group_name> --s3-location s3://<bucket_name>/csye6225-webapp-<build_num>.zip`

## Running Tests

### Unit test for backend
Navigate to webapp folder  
`cd webapp`<br><br>
Run the following command\
`mvn test`

## CI/CD

### Technology
* CircleCI

### Decription
Need 4 environment varibales
* AWS_REGION
* AWS_SECRET_KEY
* AWS_ACCESS_KEY
* AWS_CODE_DEPLOY_BUCKET

### Usage
* A git commit will automatically execute CircleCI JOB
* A job can also be initiated using the following command
`curl -u 'put_circleci_user_token' -d build_parameters[CIRCLE_JOB]=build-app https://circleci.com/api/v1.1/project/github/<username>/csye6225-spring2019/tree/<branch>`
