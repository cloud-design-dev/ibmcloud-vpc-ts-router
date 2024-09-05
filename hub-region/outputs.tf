output "prefix" {
    value = local.prefix
}

# output "ssh_public_key" {
#     value = local.ssh_public_key
# }

output "vpc" {
    value = ibm_is_vpc.vpc
}

output "resource_group_id" {
    value = module.resource_group.resource_group_id
}

