locals {
  repository_list = ["nodejs-express-mysql"]
  repositories    = { for name in local.repository_list : name => name }
}

resource "aws_ecr_repository" "main" {

  for_each = local.repositories

  name                 = "ecr-${local.application_name}-${local.env}-${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    application = local.application_name
    environment = local.env
  }

}