terraform {
  backend "s3" {
    bucket = "ecs-serh-bucket"
    key    = "prod/ecs_infra/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_key_pair" "ecs" {
  key_name   = "${var.environment}-${var.environment}-ecs-key"
  public_key = file("~/Documents/aws/aws_keys/id_rsa_ec2.pub")
}

module "ecs" {
  source = "./modules/ecs"
 
  environment          = var.environment
  cluster              = var.environment
  vpc_cidr             = var.vpc_cidr
  key_name             = aws_key_pair.ecs.key_name
  private_subnets      = var.private_subnets
  availability_zones   = var.availability_zones
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  instance_type        = var.instance_type
  aws_ami              = var.aws_ecs_ami
  db_user              = var.db_user
  db_password          = var.db_password
  db_name              = var.db_name
}
