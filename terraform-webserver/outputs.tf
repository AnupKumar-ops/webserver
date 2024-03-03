output "subnet_ids" {
  value = module.webserver_vpc.subnet_ids
}

output "vpc_id" {
  value = module.webserver_vpc.vpc_id
}

output "loadbalancer_url" {
  value = module.webserver_alb.loadbalancer_dns_name
}
