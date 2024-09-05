
# Security Group


# Tailscale vnic

resource "ibm_is_virtual_network_interface" "tailscale_subnet_router" {
  allow_ip_spoofing         = true
  auto_delete               = false
  enable_infrastructure_nat = true
  name                      = "${var.vpc_name}-ts-router-vnic"
  subnet                    = ibm_is_subnet.frontend_subnet.id
  resource_group            = var.resource_group_id
  security_groups           = [ibm_is_vpc.vpc.default_security_group]
  tags                      = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}


# Tailscale instance
resource "ibm_is_instance" "tailscale_subnet_router" {
  name           = "${var.vpc_name}-ts-router"
  vpc            = ibm_is_vpc.vpc.id
  image          = data.ibm_is_image.base.id
  profile        = var.instance_profile
  resource_group = var.resource_group_id
  metadata_service {
    enabled            = true
    protocol           = "https"
    response_hop_limit = 5
  }

  boot_volume {
    auto_delete_volume = true
    name               = "${var.vpc_name}-ts-router-boot"
  }

  primary_network_attachment {
    name = "${var.vpc_name}-primary-interface"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.tailscale_subnet_router.id
    }
  }

  zone = local.vpc_zones[0].zone
  keys = [data.ibm_is_ssh_key.sshkey.id]
  tags = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

