# webserver

# Below tools are prerequisite
terraform
ansible
python
git
aws cli

# Terraform code will create below resources
1. VPC 
2. public subnets
3. application load balancer
4. aws autoscaling group
5. s3 backend to store tfstate file
6. ec2 instance hosting web server
7. security groups for ec2. alb
8. internet gateway
9. route tables for internet 

# Below commands will be used
1. terraform init
2. terraform validate
3. terraform plan -out webserver.plan
4. terraform apply webserver.plan
