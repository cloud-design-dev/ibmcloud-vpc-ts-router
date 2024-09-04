resource "random_string" "prefix" {
  count   = var.project_prefix != "" ? 0 : 1
  length  = 4
  special = false
  numeric = false
  upper   = false
}

module "resource_group" {
  source                       = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.1.0"
  existing_resource_group_name = var.existing_resource_group
}

# VPC
resource "ibm_is_vpc" "vpc" {
  name                        = "${local.prefix}-hub-vpc"
  resource_group              = module.resource_group.resource_group_id
  classic_access              = var.classic_access
  address_prefix_management   = var.default_address_prefix
  default_network_acl_name    = "${local.prefix}-vpc-default-nacl"
  default_security_group_name = "${local.prefix}-vpc-default-sg"
  default_routing_table_name  = "${local.prefix}-vpc-default-rt"
  tags                        = local.tags
}

# Public Gateway
resource "ibm_is_public_gateway" "zone_1_pgw" {
  name           = "${local.prefix}-zone-1-pgw"
  resource_group = module.resource_group.resource_group_id
  vpc            = ibm_is_vpc.vpc.id
  zone           = local.vpc_zones[0].zone
  tags           = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

# Subnet
resource "ibm_is_subnet" "frontend_subnet" {
  name                     = "${local.prefix}-zone-1-frontend-subnet"
  resource_group           = module.resource_group.resource_group_id
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.vpc_zones[0].zone
  total_ipv4_address_count = "32"
  public_gateway           = ibm_is_public_gateway.zone_1_pgw.id
  tags                     = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

# Security Group
module "add_rules_to_default_security_group" {
  depends_on                   = [ibm_is_vpc.vpc]
  source                       = "terraform-ibm-modules/security-group/ibm"
  add_ibm_cloud_internal_rules = true
  use_existing_security_group  = true
  existing_security_group_name = ibm_is_vpc.vpc.default_security_group
  security_group_rules         = local.frontend_rules
  tags                         = local.tags
}

# Tailscale vnic

resource "ibm_is_virtual_network_interface" "tailscale_subnet_router" {
  allow_ip_spoofing         = true
  auto_delete               = false
  enable_infrastructure_nat = true
  name                      = "${local.prefix}-ts-router-vnic"
  subnet                    = ibm_is_subnet.frontend_subnet.id
  resource_group            = module.resource_group.resource_group_id
  security_groups           = [ibm_is_vpc.vpc.default_security_group]
  tags                      = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}


# Tailscale instance
resource "ibm_is_instance" "tailscale_subnet_router" {
  name           = "${local.prefix}-ts-router"
  vpc            = ibm_is_vpc.vpc.id
  image          = data.ibm_is_image.base.id
  profile        = var.instance_profile
  resource_group = module.resource_group.resource_group_id
  metadata_service {
    enabled            = true
    protocol           = "https"
    response_hop_limit = 5
  }

  boot_volume {
    auto_delete_volume = true
    name               = "${local.prefix}-ts-router-boot"
  }

  primary_network_attachment {
    name = "${local.prefix}-primary-interface"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.tailscale_subnet_router.id
    }
  }

  zone = local.vpc_zones[0].zone
  keys = [data.ibm_is_ssh_key.sshkey.id]
  tags = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

