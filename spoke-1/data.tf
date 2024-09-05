data "terraform_remote_state" "hub_region" {
  backend = "local"

  config = {
    path = "../hub-region/terraform.tfstate"
  }
}