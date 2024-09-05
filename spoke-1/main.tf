# VPC

resource "ibm_is_vpc" "vpc" {
  name                        = "${var.prefix}-spoke1-vpc"
  resource_group              = data.terraform_remote_state.hub_region.outputs.resource_group_id
  classic_access              = var.classic_access
  address_prefix_management   = var.default_address_prefix
  default_network_acl_name    = "${var.prefix}-spoke1-default-nacl"
  default_security_group_name = "${var.prefix}-spoke1-default-sg"
  default_routing_table_name  = "${var.prefix}-spoke1-default-rt"
  tags                        = local.tags
}



# PGW
# Subnet
# Security Group
# VNIC
# Instance