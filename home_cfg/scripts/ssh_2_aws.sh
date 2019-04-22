#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo ""
  echo "************************************************"
  echo "SSH to an AWS EC2 Instance using the pem file."
  echo "If no user is found then it uses ubuntu"
  echo ""
  echo "    Usage: $0 <hostname> to login" >&2
  echo "************************************************"
  echo ""
  exit 1
fi

AWS_HOSTNAME=$1
AWS_USER=ubuntu

if [[ $AWS_HOSTNAME == *"@"* ]]; then
  echo "It does have a user"
  AWS_USER=$(echo $1 | cut -f1 -d@)
  AWS_HOST=$(echo $1 | cut -f2 -d@)
else
  AWS_HOST=$AWS_HOSTNAME
fi


echo "Connecting to AWS as ${AWS_USER}@${AWS_HOST}"
ssh -X -i ~/.ssh/aws_serv_server_key.pem ${AWS_USER}@${AWS_HOST}

