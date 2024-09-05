output "vpc" {
  value = ibm_is_vpc.vpc
}

output "vpc_id" {
  value = ibm_is_vpc.vpc.id
}

output "default_security_group" {
  value = ibm_is_vpc.vpc.default_security_group
}

output "vpc_subnet_id" {
  value = ibm_is_subnet.frontend_subnet.id
}

output "vpc_subnet_cidr" {
  value = ibm_is_subnet.frontend_subnet.ipv4_cidr_block
}

output "vpc_crn" {
  value = ibm_is_vpc.vpc.crn
}
