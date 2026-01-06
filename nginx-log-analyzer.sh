#!/bin/bash

# The goal of this project is to help you practice some basic shell scripting skills. You will write a simple tool to analyze logs from the command line.

# Requirements
# Download the sample nginx access log file from here. The log file contains the following fields:
# IP address
# Date and time
# Request method and path
# Response status code
# Response size
# Referrer
# User agent

# You are required to create a shell script that reads the log file and provides the following information:
# Top 5 IP addresses with the most requests
# Top 5 most requested paths
# Top 5 response status codes
# Top 5 user agents

# Here is an example of what the output should look like:

# Top 5 IP addresses with the most requests:
# 45.76.135.253 - 1000 requests
# 142.93.143.8 - 600 requests
# 178.128.94.113 - 50 requests
# 43.224.43.187 - 30 requests
# 178.128.94.113 - 20 requests

# Top 5 most requested paths:
# /api/v1/users - 1000 requests
# /api/v1/products - 600 requests
# /api/v1/orders - 50 requests
# /api/v1/payments - 30 requests
# /api/v1/reviews - 20 requests

# Top 5 response status codes:
# 200 - 1000 requests
# 404 - 600 requests
# 500 - 50 requests
# 401 - 30 requests
# 304 - 20 requests

# There are multiple ways to solve this challenge. Do some research on awk, sort, uniq, head, grep, and sed commands.
# Stretch goal is to come up with multiple solutions for the above problem.
# For example, instead of using awk, you can use grep and sed to filter and count the requests.

log_file="nginx-access.log"

echo "Downloading sample nginx access log file..."
curl -fsSL -o "$log_file" https://gist.githubusercontent.com/kamranahmedse/e66c3b9ea89a1a030d3b739eeeef22d0/raw/77fb3ac837a73c4f0206e78a236d885590b7ae35/nginx-access.log

if [ $? -ne 0 ]; then
    echo "Error: Failed to download log file."
    exit 1
fi
echo "Download complete."

######## AWK SOLUTION ########
echo
echo "Top 5 IP addresses with the most requests:"
awk '{ print $1}' "$log_file" | sort | uniq -c | sort -nr | head -n 5 | awk '{ printf "%s - %s requests\n", $2, $1 }'
echo

echo "Top 5 most requested paths:"
awk '{ print $7} ' "$log_file" | sort | uniq -c | sort -nr | head -n 5 | awk '{ printf "%s - %s requests\n", $2, $1 }'
echo

echo "Top 5 response status codes:"
awk '{ print $9 }' "$log_file" | sort | uniq -c | sort -nr | head -n 5 | awk '{ printf "%s - %s requests\n", $2, $1 }'
echo

echo "Top 5 user agents:"
awk -F '"' ' {print $6} ' "$log_file" | sort | uniq -c | sort -nr | head -n 5 | awk '{ printf "%s - %s requests\n", substr($0, index($0,$2)), $1 }'
echo

exit 0