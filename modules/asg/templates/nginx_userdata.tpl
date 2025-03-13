#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx

# Clean the Nginx document root
sudo rm -rf /usr/share/nginx/html/*

# Pull all files from the S3 bucket's "html" directory
aws s3 cp s3://${s3_bucket}/html/ /usr/share/nginx/html/ --recursive