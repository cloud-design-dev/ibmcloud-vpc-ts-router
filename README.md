# Deploy a Tailscale Subnet Router for multi-VPC connectivity

 - [ ] Step 1: think of a better title

## Overview

Use the Tailscale [Subnet Router](https://tailscale.com/kb/1019/subnets) feature to expose routes across multiple VPCs. Subnet routers act as a gateway, relaying traffic from your tailnet to the VPC subnets without the need for each device to be running the tailscale agent.

In this example we will connect a `hub` VPC, where our Subnet Router instance is running, to our `prod` and `dev` VPCs in the same region via a local IBM Cloud [Transit Gateway](https://cloud.ibm.com/docs/transit-gateway?topic=transit-gateway-about&interface=cli). 

## Diagram

![Diagram of Tailscale deployment](./images/ibmcloud-ts-subnet-router.png)

## Pre-reqs

- [ ] IBM Cloud [API Key](https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui#create_user_key)
- [ ] Tailscale [API Key](https://login.tailscale.com/admin/settings/keys)
- [ ] Terraform [installed](https://developer.hashicorp.com/terraform/install) locally

## Getting started

### Clone repo 

### Configure tfvars file

### Plan and Apply

### Testing connectivity to compute instances

### Clean up

## Conclusion 
