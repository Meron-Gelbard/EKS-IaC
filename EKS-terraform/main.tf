module "vpc" {
  source = "./vpc_deploy"
  aws_region = var.aws_region

  cluster_name = var.cluster_name
}

module "EKS-cluster" {
  source = "./EKS_deploy"

  cluster_name = var.cluster_name
  node-count = var.node-count
  pvt-subnet-a-id = module.vpc.details["private_subnet_a_id"]
  pvt-subnet-b-id = module.vpc.details["private_subnet_b_id"]
  pub-subnet-a-id = module.vpc.details["public_subnet_a_id"]
  pub-subnet-b-id = module.vpc.details["public_subnet_b_id"]
  

  depends_on = [module.vpc]
}
