data "aws_iam_policy_document" "argocd_image_updater" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "argocd_image_updater" {
  name               = "${aws_eks_cluster.this.name}-argocd-image-updater"
  assume_role_policy = data.aws_iam_policy_document.argocd_image_updater.json
}

resource "aws_iam_role_policy_attachment" "argocd_image_updater" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.argocd_image_updater.name
}

resource "aws_eks_pod_identity_association" "argocd_image_updater" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "argocd"
  service_account = "argocd-image-updater"
  role_arn        = aws_iam_role.argocd_image_updater.arn
}

# resource "helm_release" "updater" {
#   name = "updater"

#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argocd-image-updater"
#   namespace        = "argocd"
#   create_namespace = true
#   version          = "0.12.0"

#   values = [
#     templatefile("${path.module}/values/image-updater.tftpl", {
#       ecr_url = aws_ecr_repository.main["nodejs-app"].repository_url
#     })
#   ]

#   depends_on = [helm_release.argocd]
# }
