# Deploy a Tailscale Subnet Router for multi-VPC connectivity

 - [ ] Step 1: think of a better title

## Overview

Use the Tailscale [Subnet Router]() feature to expose routes across multiple VPCs. Subnet routers act as a gateway, relaying traffic from your tailnet to the VPC subnets without the need for each device to be running the tailscale agent.

In this example we will connect a `hub` VPC, where our Subnet Router instance is running, to our `prod` and `dev` VPCs in the same region. 

## Diagram

![Diagram of Tailscale deployment](./images/ibmcloud-ts-subnet-router.png)

## Pre-reqs

- [ ] IBM Cloud [API Key]()
- [ ] Tailscale [API Key]()
- [ ] Terraform [installed]() locally

## Getting started

### Clone repo 

### Configure tfvars file

### Plan and Apply

### Testing connectivity to compute instances

### Clean up

## Conclusion 
