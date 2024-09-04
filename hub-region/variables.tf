variable "ibmcloud_api_key" {
  description = "The IBM Cloud API key to use for provisioning resources"
  type        = string
  sensitive   = true
}

variable "project_prefix" {
  description = "The prefix to use for naming resources"
  type        = string
  default     = ""
}

variable "region" {
  description = "The IBM Cloud region to use for provisioning resources"
  type        = string
}

variable "existing_resource_group" {
  description = "The IBM Cloud resource group to assign to the provisioned resources"
  type        = string
}

variable "existing_ssh_key" {
  description = "The name of an existing SSH key to use for provisioning resources"
  type        = string
  default     = ""
}

variable "classic_access" {
  description = "Whether to enable classic access for the VPC"
  type        = bool
  default     = false
}

variable "default_address_prefix" {
  description = "The default address prefix to use for the VPC"
  type        = string
  default     = "auto"

}

variable "instance_profile" {
  description = "The name of the instance profile to use for the compute instances."
  type        = string
  default     = "cx2-2x4"
}

variable "base_image" {
  description = "The name of the base image to use for the compute instances."
  type        = string
  default     = "ibm-ubuntu-22-04-4-minimal-amd64-3"
}


variable "frontend_rules" {
  description = "The list of frontend rules to create"
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

