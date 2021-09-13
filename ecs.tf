terraform {
  backend "s3" {
    bucket = "ecs-serh-bucket"
    key    = "development/ecs_infra/terraform.tfstate"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkb4KvVBYk31b8mQ5hqBWy9kLXTA2awN+yyu8FzJHeqZkwxF7XoXbMYvZ6xZ/H8Py9HRfNDQpIirJ1rmargYaWTXnl4peqMUxcIg2F/nlZUB8AKMjIFmbDnv1nvuvAdOz1XgreFIsguhzqG5Bv3kZ7xCZ4pNsq1xhv2+OOTmHzrvQu1H+hid9Or42MoWJb98neapTvIrkwW2VhbmvhSEueNihsry54TEungNvRquI7XCtfQJht8WC/W5PiMriuPi1orlJI7OZjcP3R6sSDk59Aukbet9ntFse/KwFn+gUgInjCnqJ+12eq1ZJZCYmJPFvsPzauV3tnRxkiSq2DYQERaJUZ8rIsSjT0ynAmSuAUwYdYnangGh8Q4FNGRK5fv4uTpLnRlk7yrJtqJlCuLBoDaWs1FLVvO3fajzZrHu2CpeDUCvfnUrOlc9MwGM68JO4OZNCmp868bNvQFvPcEQgX3QC2YWIQ3va/+m7+ESVlvBNWa7Aht26eQD9k2sxCdEM= EPAM+Serhii_Protsun@EPUAKYIW13FA" 
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
