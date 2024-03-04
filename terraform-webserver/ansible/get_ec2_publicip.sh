#! /bin/bash
rm -rf inventory/hosts
echo "[webservers]" > inventory/hosts
ips=`aws ec2 describe-instances  --profile awsadminuser --region ap-south-1 --filters "Name=tag:environment,Values=dev" --query "Reservations[].Instances[].PublicIpAddress" --output text`
for ip in $ips
do
  echo $ip >> inventory/hosts
done
#echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory/hosts

#echo "webserver ansible_ssh_private_key_file=~/home/ec2user/$2.pem" >> inventory/hosts
