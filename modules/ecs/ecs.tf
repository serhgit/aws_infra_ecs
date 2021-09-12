module "vpc" {
  source = "../vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
#  public_subnet_cidrs  = var.public_subnets
  private_subnets      = var.private_subnets
  availability_zones   = var.availability_zones
  depends_id           = ""
}

module "ecs_instances" {
  source = "../ecs_instances"
 
   environment             = var.environment
   cluster                 = var.cluster
   instance_type           = var.instance_type
   vpc_id                  = module.vpc.id
   aws_ami                 = var.aws_ami
   iam_instance_profile_arn = aws_iam_instance_profile.ecs.arn
   key_name                = var.key_name
   min_size                = var.min_size
   max_size                = var.max_size
   desired_capacity        = var.desired_capacity
   private_subnet_ids      = module.vpc.private_subnet_ids
}

module "rds" {
  source = "../rds"

  environment             = var.environment
  cluster                 = var.cluster
  size                    = 2
  rds_security_group_id   = module.ecs_instances.ecs_instance_sg_id
  db_subnet_ids           = module.vpc.private_subnet_ids
  db_user                 = var.db_user
  db_password             = var.db_password
  db_name                 = var.db_name
}

module "secret_manager" {
 source = "../secret_manager"

 environment = var.environment
 cluster     = var.cluster
 db_details  = {
    db_user     = "${var.db_user}"
    db_password = "${var.db_password}"
    db_name     = "${var.db_name}"
    db_write_host = "${module.rds.db_write_host}"
 }
 bucket_name = "${module.s3.s3_bucket_name}"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster
}

module "s3" {
  source = "../s3"

  environment = var.environment
  cluster     = var.cluster
}
