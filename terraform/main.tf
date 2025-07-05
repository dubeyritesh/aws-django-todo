provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3"
}

# Backend config (optional)
# terraform {
#   backend "s3" {
#     bucket = "my-terraform-state-bucket"
#     key    = "aws-django-todo/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu Official)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Load all modules/resources
module "network" {
  source = "./modules/network"
}

module "security" {
  source         = "./modules/security"
  vpc_id         = module.network.vpc_id
  static_bucket  = var.static_bucket
}

module "s3" {
  source        = "./modules/s3"
  bucket_name   = var.static_bucket
}

# module "ec2" {
#   source             = "./modules/ec2"
#   vpc_id             = module.network.vpc_id
#   subnet_id          = module.network.public_subnet_ids[0]
#   rds_endpoint       = module.rds.rds_endpoint
#   db_name            = var.db_name
#   db_username        = var.db_username
#   db_password        = var.db_password
#   bucket_name        = var.static_bucket
#   instance_count     = 1
# }



module "rds" {
  source             = "./modules/rds"
  db_identifier      = "todo-db"
  db_name            = var.db_name
  db_user            = var.db_user
  db_password        = var.db_password
  private_subnet_ids = module.network.private_subnet_ids
  db_sg_id           = module.security.rds_sg_id
}

module "ec2" {
  source           = "./modules/ec2"
  private_subnet_ids   = module.network.private_subnet_ids
  ec2_sg_id        = module.security.ec2_sg_id
  key_name         = var.key_name

  db_name          = var.db_name
  db_user          = var.db_user
  db_password      = var.db_password
  db_host          = module.rds.db_endpoint
  static_bucket    = var.static_bucket
  git_repo         = var.git_repo
}

module "alb" {
  source            = "./modules/alb"
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  vpc_id            = module.network.vpc_id
}

module "asg" {
  source            = "./modules/asg"
  ami_id            = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  key_name          = var.key_name
  ec2_sg_id         = module.security.ec2_sg_id
  public_subnet_ids = module.network.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
  instance_profile_name = module.security.ec2_instance_profile

  db_name       = var.db_name
  db_user       = var.db_user
  db_password   = var.db_password
  db_host       = module.rds.db_endpoint
  static_bucket = var.static_bucket
  git_repo      = var.git_repo
}

module "monitoring" {
  source    = "./modules/monitoring"
  asg_name  = module.asg.asg_name
  alb_name  = module.alb.alb_name
}

module "cloudtrail" {
  source = "./modules/cloudtrail"
}

module "waf" {
  source   = "./modules/waf"
  alb_arn  = module.alb.alb_arn
}




