terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.69.0-beta1"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.16.2"
    }
  }
}
