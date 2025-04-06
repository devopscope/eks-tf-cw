output "eks_name" {
  value = aws_eks_cluster.this.name
}

output "node_group_id" {
  value = aws_eks_node_group.general["general"].id
}
# output "openid_provider_arn" {
#   value = aws_iam_openid_connect_provider.this[0].arn
# }