provider "aws" {
  region = "${var.location}"
}

# Create the VPC and subnet
module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"

  name                  = "${var.vpc_name}"
  cidr                  = "${var.network}"
  azs                   = "${var.zones}"
  public_subnets        = ["${var.nat_subnet}"]
  private_subnets       = "${var.subnets}"
  enable_nat_gateway    = true
  enable_vpn_gateway    = true
  enable_dns_hostnames  = true
  single_nat_gateway    = true

  tags                  = "${var.tags}"
  private_subnet_tags   = {
                            tier = "private"
                          }
  public_subnet_tags   = {
                            tier = "public"
                          }
}


# Create security rules
module "security_group" {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group"

  name        = "admin"
  description = "Security group for ssh, https input and all output"
  vpc_id      = "${module.vpc.vpc_id}"
  
  # Allow ping between private subnets
  ingress_cidr_blocks = "${var.subnets}"
  ingress_rules = ["all-all"]

  # Allow SSH and RDP from all internal network
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "rdp"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      from_port   = 8
      to_port     = 0
      protocol    = "icmp"
      description = "ping"
      cidr_blocks = "10.0.0.0/8"
    },
  ]
  
  # Allow icmp, web, dns and ntp
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-icmp", "http-80-tcp", "https-443-tcp", "dns-udp", "dns-tcp", "ntp-udp"]
}