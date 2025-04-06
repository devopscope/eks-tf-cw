provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "volkan-cw"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}

module "vpc" {
  source = "../../modules/vpc"

  env = var.env
  vpc_cidr_block = var.vpc_cidr_block
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
  env         = var.env
  eks_name    = var.project_name
  eks_version = "1.30"
  subnet_ids  = module.vpc.private_subnet_ids
  node_groups = {
    general = {
      capacity_type  = "SPOT"
      instance_types = ["t3.large"]
      scaling_config = {
        desired_size = 1
        max_size     = 2
        min_size     = 1
      }
    }
  }
}

module "rds_mysql" {
  source = "../../modules/rds-mysql"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_password_secret_name = "mysql-db-password2"
  rds_instance_class = "db.t3.micro"
  allocated_storage = "10"
  db_name = "testdb"
  db_username = "admin"
  engine_version = "8.0"
}
