resource "ibm_tg_gateway" "lab" {
  name           = var.name
  location       = var.region
  global         = false
  resource_group = var.resource_group_id
}
