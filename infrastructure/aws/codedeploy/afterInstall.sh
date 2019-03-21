#!/bin/bash

sudo systemctl stop tomcat.service

sudo systemctl stop cloudwatch.service

sudo rm -rf /opt/tomcat/webapps/docs  /opt/tomcat/webapps/examples /opt/tomcat/webapps/host-manager  /opt/tomcat/webapps/manager /opt/tomcat/webapps/ROOT

sudo mv /opt/tomcat/webapps/*.war /opt/tomcat/webapps/ROOT.war

sudo chown tomcat:tomcat /opt/tomcat/webapps/ROOT.war

# cleanup log files
sudo rm -rf /opt/tomcat/logs/catalina*
sudo rm -rf /opt/tomcat/logs/*.log
sudo rm -rf /opt/tomcat/logs/*.txt

cd /opt/aws/amazon-cloudwatch-agent/bin/

cd /home/centos

echo '{"agent": {"metrics_collection_interval": 10,"logfile": "/var/logs/amazon-cloudwatch-agent.log"},"logs": {"logs_collected": {"files": {"collect_list": [{"file_path":"/opt/tomcat/logs/csye6225.log","log_group_name": "csye6225_spring2019","log_stream_name": "webapp"}]}},"log_stream_name": "cloudwatch_log_stream"},"metrics":{"metrics_collected":{"statsd":{"service_address":":8125","metrics_collection_interval":10,"metrics_aggregation_interval":60}}}}' > cloudwatch-config.json

sudo mv /home/centos/cloudwatch-config.json /opt/aws/amazon-cloudwatch-agent/bin/

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-config.json -s

echo 'sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch-config.json -s' > awslogs-agent-launcher.sh

sudo mv /home/centos/awslogs-agent-launcher.sh /opt/aws/amazon-cloudwatch-agent/bin/
