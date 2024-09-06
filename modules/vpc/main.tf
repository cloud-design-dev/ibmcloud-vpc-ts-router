

# VPC
resource "ibm_is_vpc" "vpc" {
  name                        = var.vpc_name
  resource_group              = var.resource_group_id
  classic_access              = var.classic_access
  address_prefix_management   = var.default_address_prefix
  default_network_acl_name    = "${var.vpc_name}-default-acl"
  default_security_group_name = "${var.vpc_name}-default-sg"
  default_routing_table_name  = "${var.vpc_name}-default-rt"
  tags                        = var.tags
}

resource "ibm_is_vpc_address_prefix" "vpc" {
  name       = "${var.vpc_name}-${var.zone}-prefix"
  zone       = var.zone
  vpc        = ibm_is_vpc.vpc.id
  cidr       = var.address_prefix
  is_default = true
}

# Public Gateway
resource "ibm_is_public_gateway" "pgw" {
  name           = "${var.vpc_name}-${var.zone}-pgw"
  resource_group = var.resource_group_id
  vpc            = ibm_is_vpc.vpc.id
  zone           = var.zone
  tags           = concat(var.tags, ["zone:${var.zone}"])
}

# Subnet
resource "ibm_is_subnet" "frontend_subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.vpc]
  name            = "${var.vpc_name}-${var.zone}-subnet"
  resource_group  = var.resource_group_id
  vpc             = ibm_is_vpc.vpc.id
  zone            = var.zone
  ipv4_cidr_block = var.subnet_cidr
  public_gateway  = ibm_is_public_gateway.pgw.id
  tags            = concat(var.tags, ["zone:${var.zone}"])
}


# module "add_rules_to_default_security_group" {
#   depends_on                   = [ibm_is_vpc.vpc]
#   source                       = "terraform-ibm-modules/security-group/ibm"
#   add_ibm_cloud_internal_rules = true
#   use_existing_security_group  = true
#   existing_security_group_name = ibm_is_vpc.vpc.default_security_group
#   security_group_rules         = var.security_group_rules
#   tags                         = var.tags
# }

# module "add_rules_to_default_security_group" {
#   depends_on                   = [ibm_is_vpc.vpc]
#   source                       = "terraform-ibm-modules/security-group/ibm"
#   add_ibm_cloud_internal_rules = true
#   use_existing_security_group  = true
#   existing_security_group_name = ibm_is_vpc.vpc.default_security_group
#   security_group_rules         = var.security_group_rules
#   tags                         = var.tags
# }

# security_group_rules         = [{
#   name      = "allow-all-inbound"
#   direction = "inbound"
#   remote    = "0.0.0.0/0"
# }]

# hub_allowed_cidr