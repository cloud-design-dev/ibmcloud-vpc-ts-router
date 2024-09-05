variable "ibmcloud_api_key" {
  description = "The IBM Cloud API key to use for provisioning resources"
  type        = string
  sensitive   = true
}

variable "tailscale_api_key" {
  description = "The Tailscale API key"
  type        = string
  sensitive   = true
}

variable "tailscale_tailnet_id" {}

variable "project_prefix" {
  description = "The prefix to use for naming resources"
  type        = string
  default     = ""
}

variable "ibmcloud_region" {
  description = "The IBM Cloud region to use for provisioning resources"
  type        = string
}

variable "existing_resource_group" {
  description = "The IBM Cloud resource group to assign to the provisioned resources"
  type        = string
}

variable "existing_ssh_key" {
  description = "The name of an existing SSH key to use for provisioning resources. If one is not provided, a new key will be generated."
  type        = string
  default     = ""
}

variable "hub_rules" {
  description = "The list of hub vpc security group rules to create"
  type = list(
    object({
      name      = string
      direction = string
      remote    = string
      tcp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      udp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      icmp = optional(
        object({
          type = optional(number)
          code = optional(number)
        })
      )
    })
  )
  default = [
    {
      name       = "inbound-ts-cidr-ssh"
      direction  = "inbound"
      remote     = "100.64.0.0/10"
      ip_version = "ipv4"
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
    {
      name       = "inbound-icmp"
      direction  = "inbound"
      remote     = "0.0.0.0/0"
      ip_version = "ipv4"
      icmp = {
        code = 0
        type = 8
      }
    },
    {
      name       = "all-outbound"
      direction  = "outbound"
      remote     = "0.0.0.0/0"
      ip_version = "ipv4"
    }
  ]
}

variable "spoke_rules" {
  description = "The list of spoke vpc security group rules to create"
  type = list(
    object({
      name      = string
      direction = string
      remote    = string
      tcp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      udp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      icmp = optional(
        object({
          type = optional(number)
          code = optional(number)
        })
      )
    })
  )
  default = [
    {
      name       = "inbound-hub-cidr-ssh"
      direction  = "inbound"
      remote     = "10.64.0.0/10"
      ip_version = "ipv4"
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
    {
      name       = "inbound-icmp"
      direction  = "inbound"
      remote     = "0.0.0.0/0"
      ip_version = "ipv4"
      icmp = {
        code = 0
        type = 8
      }
    },
    {
      name       = "all-outbound"
      direction  = "outbound"
      remote     = "0.0.0.0/0"
      ip_version = "ipv4"
    }
  ]
}

variable "hub_prefix" {
  description = "The address prefix to use for the hub VPC"
  type        = string
  default     = "192.168.0.0/18"
}

variable "prod_prefix" {
  description = "The address prefix to use for the prod_vpc VPC"
  type        = string
  default     = "172.16.0.0/18"
}

variable "dev_prefix" {
  description = "The address prefix to use for the dev_vpc VPC"
  type        = string
  default     = "172.16.64.0/18"
}
