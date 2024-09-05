variable "ibmcloud_api_key" {
  description = "The IBM Cloud API key to use for provisioning resources"
  type        = string
  sensitive   = true
}


variable "spoke_1_region" {
  description = "Spoke region #1"
  type        = string
}
