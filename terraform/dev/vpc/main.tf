provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "local" {
    path = "dev/vpc/terraform.tfstate"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  env = "dev"
  #   zone1    = "us-east-1a"
  #   zone2    = "us-east-1b"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets  = ["10.0.64.0/19", "10.0.96.0/19"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/dev-demo"  = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/dev-demo" = "owned"
  }
}

module "eks" {
  source      = "../../modules/eks"
  env         = "dev"
  eks_name    = "cw"
  eks_version = "1.30"
  subnet_ids  = module.vpc.private_subnet_ids
  node_groups = {
    general = {
      capacity_type  = "SPOT"
      instance_types = ["t3.small"]
      scaling_config = {
        desired_size = 2
        max_size     = 3
        min_size     = 2
      }
    }
  }

}
