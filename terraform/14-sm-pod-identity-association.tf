# data "aws_iam_policy_document" "secrets_manager_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "secretsmanager:GetSecretValue",
#       "secretsmanager:DescribeSecret"
#     ]
#     resources = [aws_secretsmanager_secret.db_password.arn]
#   }
# }

# data "aws_iam_policy_document" "assume_role_policy" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["pods.eks.amazonaws.com"]
#     }

#     actions = [
#       "sts:AssumeRole",
#       "sts:TagSession"
#     ]
#   }
# }

# resource "aws_iam_policy" "secrets_manager_policy" {
#   name        = "mysql-secrets-policy"
#   description = "Policy for accessing MySQL password from Secrets Manager"
#   policy      = data.aws_iam_policy_document.secrets_manager_policy.json
# }

# resource "aws_iam_role" "secrets_manager_role" {
#   name = "mysql-secrets-role"

#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
# }

# resource "aws_iam_role_policy_attachment" "secrets_manager_policy_attachment" {
#   role       = aws_iam_role.secrets_manager_role.name
#   policy_arn = aws_iam_policy.secrets_manager_policy.arn
# }

# resource "aws_eks_pod_identity_association" "mysql-secrets-association" {
#   cluster_name    = aws_eks_cluster.eks.name
#   namespace       = "default"
#   service_account = "mysql-secrets-sa"
#   role_arn        = aws_iam_role.secrets_manager_role.arn
# }

# output "secrets_manager_role_arn" {
#   value = aws_iam_role.secrets_manager_role.arn
# } 