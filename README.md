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
Run the following command\

### For Default profile
`./mvnw spring-boot:run -Dspring-boot.run.profiles=default -Dspring-boot.run.arguments=--spring.bucket.name=*bucket-name*

### For Dev profile
`./mvnw spring-boot:run -Dspring-boot.run.profiles=dev -Dspring-boot.run.arguments=--spring.bucket.name=*bucket-name*,--spring.datasource.url=jdbc:mysql://*endpoint-url*/csye6225`

## Deploy Instructions

XXXX

## Running Tests

### Unit test for backend
Navigate to webapp folder  
`cd webapp`<br><br>
Run the following command\
`mvn test`

## CI/CD

XXXX
