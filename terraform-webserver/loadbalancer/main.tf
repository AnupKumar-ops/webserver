##Application load balancer security group creation

resource "aws_security_group" "webserver-alb-sg" {
  name        = "${var.app_arguments["common_name"]}-alb-sg"
  description = "Allow  inbound traffic for ALB"
  vpc_id      = var.vpcid

  tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-alb-sg" })

  ingress {
    from_port   = 80
    to_port     = 80
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


### Load Balancer creation
resource "aws_lb" "webserver-alb" {
  name               = "${var.app_arguments["common_name"]}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver-alb-sg.id]
  subnets            = var.subnets_id


  tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-alb" })
}


## target groups creation
resource "aws_lb_target_group" "webserver-tg" {
  name        = "${var.app_arguments["common_name"]}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpcid

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200,202,302"
  }

  tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-tg" })
}

resource "aws_lb_listener" "webserver-alb-listener" {
  load_balancer_arn = aws_lb.webserver-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver-tg.arn
  }
}
