module "webserver_vpc" {
  source        = "./network"
  app_arguments = var.app_arguments
}

module "webserver_alb" {
  source        = "./loadbalancer"
  app_arguments = var.app_arguments
  subnets_id    = module.webserver_vpc.subnet_ids
  vpcid         = module.webserver_vpc.vpc_id
}

module "generate_keypair" {
  source       = "./ec2keypair"
  keypairname  = var.app_arguments["autoscaling_arguments"]["ec2_key_pair"]
  region       = var.region
  profile_name = var.profile_name
  depends_on   = [module.webserver_alb]
}

module "webserver_asg" {
  source              = "./autoscale"
  app_arguments       = var.app_arguments
  vpc_id              = module.webserver_vpc.vpc_id
  subnet_ids          = module.webserver_vpc.subnet_ids
  target_group_arn    = module.webserver_alb.target_group_arn
  webserver_alb_sg_id = module.webserver_alb.webserver_alb_sg_id
  depends_on          = [module.generate_keypair]
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
  depends_on      = [module.webserver_asg]
}

module "webserver_deployment" {
  source          = "./ansible"
  instance_region = var.region
  keypairname     = var.app_arguments["autoscaling_arguments"]["ec2_key_pair"]
  depends_on      = [module.webserver_asg, time_sleep.wait_30_seconds]
}
