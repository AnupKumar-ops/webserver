#! /bin/bash

#aws ec2 create-key-pair --key-name "$1" --region "$2" --profile "$3" --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath /home/ec2-user/"$1".pem

aws ec2 create-key-pair --key-name "$1" --region "$2" --profile "$3" --query 'KeyMaterial' --output text > /tmp/"$1".pem
chmod 400 /tmp/"$1".pem

aws ec2 describe-key-pairs --key-name "$1" --region "$2" --profile "$3"
