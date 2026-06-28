module "vpc" {
  source = "../../modules/vpc"

  project_name        = var.project_name
  environment         = var.environment

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

  availability_zone   = var.availability_zone

}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  my_ip = var.my_ip
}

module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id

  bastion_sg_id     = module.security_groups.bastion_sg_id
  private_ec2_sg_id = module.security_groups.private_ec2_sg_id
}