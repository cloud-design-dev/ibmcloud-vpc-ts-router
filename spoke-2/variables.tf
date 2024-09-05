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

variable "spoke_2_region" {
  description = "The IBM Cloud region to use for provisioning resources"
  type        = string
}
