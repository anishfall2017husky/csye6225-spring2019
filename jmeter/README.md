## Getting Started

Clone the repository on your local machine

### Prerequisites

Install jmeter binary from [Apache Jmeter](http://jmeter.apache.org/)
Execute below commad in terminal 
```
bash on bin/jmeter.sh
```

### Execution steps
1. Load cloudApp.jmx in jmeter 
2. Change the server Id in Thread 1 and Thread 2 to your domain name
3. Change the csv directory path in CSV Data Set Config in Thread 1 and Thread 2 to your local directory path
4. Run the thread 1 which will create 1000 users
5. Run the thread 2 which will create transactions and attachments for users created above
