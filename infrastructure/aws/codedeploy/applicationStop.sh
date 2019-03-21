#!/bin/bash

sudo systemctl daemon-reload
sudo systemctl stop tomcat.service

sudo systemctl stop cloudwatch.service
