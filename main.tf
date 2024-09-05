# If no project prefix is defined, generate a random one 
resource "random_string" "prefix" {
  count   = var.project_prefix != "" ? 0 : 1
  length  = 4
  special = false
  numeric = false
  upper   = false
}

resource "tailscale_tailnet_key" "lab" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  expiry        = 3600
  description   = "Demo tailscale key for lab"
}

# If an existing resource group is provided, this module returns the ID, otherwise it creates a new one and returns the ID
module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.5"
  resource_group_name          = var.existing_resource_group == null ? "${local.prefix}-resource-group" : null
  existing_resource_group_name = var.existing_resource_group
}

resource "tls_private_key" "ssh" {
  count     = var.existing_ssh_key != "" ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "generated_key" {
  count          = var.existing_ssh_key != "" ? 0 : 1
  name           = "${local.prefix}-${var.ibmcloud_region}-sshkey"
  resource_group = module.resource_group.resource_group_id
  public_key     = tls_private_key.ssh.0.public_key_openssh
  tags           = local.tags
}

module "hub_vpc" {
  source            = "./modules/vpc"
  vpc_name          = "${local.prefix}-hub"
  resource_group_id = module.resource_group.resource_group_id
  address_prefix    = var.hub_prefix
  tags              = concat(local.tags, ["environment:network_hub"])
  zone              = local.vpc_zones[0].zone
  subnet_cidr       = local.hub_subnet_cidr
}

module "add_rules_to_hub_vpc_security_group" {
  depends_on                   = [module.hub_vpc]
  source                       = "terraform-ibm-modules/security-group/ibm"
  add_ibm_cloud_internal_rules = true
  use_existing_security_group  = true
  existing_security_group_name = module.hub_vpc.default_security_group
  security_group_rules = [{
    name      = "allow-ts-cidr-ssh-inbound"
    direction = "inbound"
    remote    = "100.64.0.0/10"
    },
    {
      name      = "allow-icmp-inbound"
      direction = "inbound"
      icmp = {
        type = 8
      }
      remote = "100.64.0.0/10"
    }
  ]
  tags = local.tags
}

module "prod_vpc" {
  source            = "./modules/vpc"
  vpc_name          = "${local.prefix}-prod"
  resource_group_id = module.resource_group.resource_group_id
  address_prefix    = var.prod_prefix
  tags              = concat(local.tags, ["environment:production"])
  zone              = local.vpc_zones[0].zone
  subnet_cidr       = local.prod_subnet_cidr
}

module "add_rules_to_prod_vpc_security_group" {
  depends_on                   = [module.prod_vpc]
  source                       = "terraform-ibm-modules/security-group/ibm"
  add_ibm_cloud_internal_rules = true
  use_existing_security_group  = true
  existing_security_group_name = module.prod_vpc.default_security_group
  security_group_rules = [{
    name      = "allow-hub-cidr-ssh-inbound"
    direction = "inbound"
    remote    = local.hub_subnet_cidr
    tcp = {
      port_min = 22
      port_max = 22
    }
    },
    {
      name      = "allow-icmp-inbound"
      direction = "inbound"
      icmp = {
        type = 8
      }
      remote = local.hub_subnet_cidr
    }
  ]
  tags = local.tags
}

module "dev_vpc" {
  source            = "./modules/vpc"
  vpc_name          = "${local.prefix}-dev"
  resource_group_id = module.resource_group.resource_group_id
  address_prefix    = var.dev_prefix
  tags              = concat(local.tags, ["environment:development"])
  zone              = local.vpc_zones[0].zone
  subnet_cidr       = local.dev_subnet_cidr
}

module "add_rules_to_dev_vpc_security_group" {
  depends_on                   = [module.dev_vpc]
  source                       = "terraform-ibm-modules/security-group/ibm"
  add_ibm_cloud_internal_rules = true
  use_existing_security_group  = true
  existing_security_group_name = module.dev_vpc.default_security_group
  security_group_rules = [{
    name      = "allow-hub-cidr-ssh-inbound"
    direction = "inbound"
    remote    = local.hub_subnet_cidr
    tcp = {
      port_min = 22
      port_max = 22
    }
    },
    {
      name      = "allow-icmp-inbound"
      direction = "inbound"
      icmp = {
        type = 8
      }
      remote = local.hub_subnet_cidr
    }
  ]
  tags = local.tags
}

module "transit_gateway" {
  source            = "./modules/transit-gateway"
  name              = "${local.prefix}-transit-gateway"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.ibmcloud_region
  hub_vpc_crn       = module.hub_vpc.vpc_crn
  prod_vpc_crn      = module.prod_vpc.vpc_crn
  dev_vpc_crn       = module.dev_vpc.vpc_crn
}

module "ts_router" {
  source                     = "./modules/compute"
  name                       = "${local.prefix}-ts-router"
  zone                       = local.vpc_zones[0].zone
  vpc_id                     = module.hub_vpc.vpc_id
  subnet_id                  = module.hub_vpc.vpc_subnet_id
  resource_group_id          = module.resource_group.resource_group_id
  tags                       = local.tags
  vpc_default_security_group = module.hub_vpc.default_security_group
  cloud_init = base64encode(templatefile("./ts-router.yaml", {
    hub_route             = local.hub_subnet_cidr
    prod_route            = local.prod_subnet_cidr
    dev_route             = local.dev_subnet_cidr
    tailscale_tailnet_key = tailscale_tailnet_key.lab.key
  }))

  # = templatefile("./cloud-init/ts-router.yaml", { tailscale_tailnet_key = tailscale_tailnet_key.lab.key })
  ssh_key_ids = local.ssh_key_ids
}

# module "tailscale" {
# depends_on = [module.ts_compute]
#   source     = "./modules/tailscale"
#   lab_routes = [local.hub_subnet_cidr, local.prod_subnet_cidr, local.dev_subnet_cidr]
# }