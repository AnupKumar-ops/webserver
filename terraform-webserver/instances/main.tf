## data dource for zones
data "aws_availability_zones" "available" {
  state = "available"
}


## create an instance for HDM
resource "aws_instance" "hdm" {
  count                       = var.instance_count["hdm"]
  ami                         = var.ami_id
  instance_type               = var.instance_type["hdm"]
  key_name                    = var.ec2_key_pair
  subnet_id                   = var.subnet_id[count.index]
  vpc_security_group_ids      = [var.webserver-sg]
  associate_public_ip_address = "true"

  tags = merge(var.tags, { Name = "${var.common_name}-0${count.index}" })
}
