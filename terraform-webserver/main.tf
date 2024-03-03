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

module "webserver_asg" {
  source              = "./autoscale"
  app_arguments       = var.app_arguments
  vpc_id              = module.webserver_vpc.vpc_id
  subnet_ids          = module.webserver_vpc.subnet_ids
  target_group_arn    = module.webserver_alb.target_group_arn
  webserver_alb_sg_id = module.webserver_alb.webserver_alb_sg_id
}
