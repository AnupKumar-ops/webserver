## instance security group

resource "aws_security_group" "webserver-ec2-sg" {
  name        = "${var.app_arguments["common_name"]}-ec2-sg"
  description = "Allow  inbound traffic for EC2"
  vpc_id      = var.vpc_id

  tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-ec2-sg" })

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.webserver_alb_sg_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



## webserver launch template

resource "aws_launch_template" "webserver-launch-template" {
  name                                 = "${var.app_arguments["common_name"]}-launch-template"
  image_id                             = var.app_arguments["autoscaling_arguments"]["ami_id"]
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.app_arguments["autoscaling_arguments"]["instance_type"]
  key_name                             = var.app_arguments["autoscaling_arguments"]["ec2_key_pair"]
  vpc_security_group_ids               = [aws_security_group.webserver-ec2-sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-instance" })
  }

  #  user_data = filebase64("${path.module}/webserver.sh")

}


## auotoscaling group
resource "aws_autoscaling_group" "webserver-autoscaling-group" {
  name                      = "${var.app_arguments["common_name"]}-asg"
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 360
  default_cooldown          = 360
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.webserver-launch-template.id
    version = "$Latest"
  }

}
