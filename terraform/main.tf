terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "homelab_server" {
  source = "./modules/ec2-instance"

  instance_type = var.instance_type
  instance_name = "homelab-${var.environment}"
  ssh_key_name  = aws_key_pair.homelab.key_name
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  allowed_cidrs = var.allowed_cidrs

  tags = {
    Environment = var.environment
    Project     = "homelab"
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr      = var.vpc_cidr
  environment   = var.environment
}

resource "aws_key_pair" "homelab" {
  key_name   = "homelab-${var.environment}"
  public_key = var.ssh_public_key
}
