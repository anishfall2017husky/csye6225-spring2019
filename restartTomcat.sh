#!/bin/sh

sudo service tomcat stop
cd /opt/tomcat/webapps
sudo rm -rf ROOT
sudo systemctl start tomcat
