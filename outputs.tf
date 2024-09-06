output "ts_router_ip" {
  value = module.ts_router.compute_instance_ip
}

output "dev_node_ip" {
  value = module.dev_compute.compute_instance_ip
}

output "prod_node_ip" {
  value = module.prod_compute.compute_instance_ip
}

output "hub_vpc_subnet" {
  value = module.hub_vpc.vpc_subnet_cidr
}

output "prod_vpc_subnet" {
  value = module.prod_vpc.vpc_subnet_cidr
}

output "dev_vpc_subnet" {
  value = module.dev_vpc.vpc_subnet_cidr
}