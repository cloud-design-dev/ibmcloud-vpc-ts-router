locals {
  prefix           = var.project_prefix != "" ? var.project_prefix : "${random_string.prefix.0.result}"
  hub_subnet_cidr  = cidrsubnet(var.hub_prefix, 8, 0)
  prod_subnet_cidr = cidrsubnet(var.prod_prefix, 8, 0)
  dev_subnet_cidr  = cidrsubnet(var.dev_prefix, 8, 0)
  ssh_key_ids      = var.existing_ssh_key != "" ? [data.ibm_is_ssh_key.sshkey[0].id] : [ibm_is_ssh_key.generated_key[0].id]
  zones            = length(data.ibm_is_zones.regional.zones)
  vpc_zones = {
    for zone in range(local.zones) : zone => {
      zone = "${var.ibmcloud_region}-${zone + 1}"
    }
  }

  tags = [
    "provider:ibm",
    "region:${var.ibmcloud_region}"
  ]
}