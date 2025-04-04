locals {
  repository_list = ["nodejs-app"]
  repositories    = { for name in local.repository_list : name => name }
  # env             = "dev"
}

resource "aws_ecr_repository" "main" {

  for_each = local.repositories

  name                 = "ecr-${var.env}-${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    environment = var.env
  }
 
}
