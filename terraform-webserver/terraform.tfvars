region       = "ap-south-1"
profile_name = "awsadminuser"

app_arguments = {

  network_arguments = {
    vpc_cidr     = "192.168.11.0/24"
    subnet_count = 2
  }

  autoscaling_arguments = {
    ami_id         = "ami-05a5bb48beb785bf1"
    ec2_key_pair   = "webapp"
    instance_type  = "t2.micro"
    instance_count = 1
  }

  common_name = "webapp"

  tags = {
    environment = "dev"
  }

}
