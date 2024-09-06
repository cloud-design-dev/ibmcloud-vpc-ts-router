output "dev_node_ip" {
  value = module.dev_compute.compute_instance_ip
}

output "prod_node_ip" {
  value = module.prod_compute.compute_instance_ip
}