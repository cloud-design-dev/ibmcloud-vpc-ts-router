variable "vpc_name" {
  description = "The name of the VPC to create"
  type        = string
}

variable "classic_access" {
  description = "Whether to enable classic access for the VPC"
  type        = bool
  default     = false
}

variable "default_address_prefix" {
  description = "The default address prefix to use for the VPC"
  type        = string
  default     = "manual"
}

variable "resource_group_id" {
  description = "The ID of the resource group to use for the VPC"
  type        = string
}

variable "tags" {}
variable "zone" {}
variable "address_prefix" {}
variable "subnet_cidr" {}