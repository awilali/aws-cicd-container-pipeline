module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
}

module "subnets" {
  source              = "./modules/subnets"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  environment         = var.environment
}

module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "ec2-ecr" {
  source             = "./modules/ec2-ecr"
  public_subnet_1_id = module.subnets.public_subnet_1_id
  public_subnet_2_id = module.subnets.public_subnet_2_id
  security_group_id  = module.security_groups.ec2_sg_id
  key_pair_name      = var.key_pair_name
  environment        = var.environment
}
