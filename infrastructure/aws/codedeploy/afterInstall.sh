#!/bin/bash

sudo systemctl stop tomcat.service

sudo rm -rf /opt/tomcat/webapps/docs  /opt/tomcat/webapps/examples /opt/tomcat/webapps/host-manager  /opt/tomcat/webapps/manager /opt/tomcat/webapps/ROOT

sudo mv /opt/tomcat/webapps/*.war /opt/tomcat/webapps/ROOT.war

sudo chown tomcat:tomcat /opt/tomcat/webapps/ROOT.war

# cleanup log files
sudo rm -rf /opt/tomcat/logs/catalina*
sudo rm -rf /opt/tomcat/logs/*.log
sudo rm -rf /opt/tomcat/logs/*.txt

cd /home/centos

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-config.json -s

echo 'sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-config.json -s' > awslogs-agent-launcher.sh

sudo chmod +x /home/centos/awslogs-agent-launcher.sh

sudo mv /home/centos/awslogs-agent-launcher.sh /opt/aws/amazon-cloudwatch-agent/bin/
