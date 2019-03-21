#!/bin/bash

sudo systemctl daemon-reload
sudo systemctl start tomcat.service

sudo systemctl start cloudwatch.service
sudo systemctl enable cloudwatch.service
