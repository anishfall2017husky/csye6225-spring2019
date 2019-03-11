#!/bin/sh

sudo service tomcat stop
cd /opt/tomcat/webapps
sudo systemctl start tomcat
