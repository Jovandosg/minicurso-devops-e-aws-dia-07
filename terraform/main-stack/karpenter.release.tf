# resource "helm_release" "karpenter" {
#   name       = "karpenter"
#   repository = "oci://public.ecr.aws/karpenter"
#   chart      = "karpenter"
#   version    = "1.5.0"
#   namespace  = "kube-system"
#   values = [
#     "${templatefile("./karpenter/values.yml", {
#       NODEGROUP = aws_eks_node_group.this.node_group_name,
#     })}"
#   ]

#   set {
#     name  = "settings.clusterName"
#     value = aws_eks_cluster.this.id
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.karpenter_controller.arn
#   }

#   set {
#     name  = "controller.resources.requests.cpu"
#     value = 1
#   }

#   set {
#     name  = "controller.resources.requests.memory"
#     value = "1Gi"
#   }

#   set {
#     name  = "controller.resources.limits.cpu"
#     value = 1
#   }

#   set {
#     name  = "controller.resources.limits.memory"
#     value = "1Gi"
#   }
# }

# resource "kubernetes_manifest" "node_pool" {
#   manifest = yamldecode(file("./karpenter/node-pool.yml"))
# }

# resource "kubernetes_manifest" "node_class" {
#   manifest = yamldecode(templatefile("./karpenter/node-class.yml", {
#     CLUSTER_NAME = aws_eks_cluster.this.id,
#     ROLE_NAME    = aws_iam_role.eks_node_group.name
#   }))
# }
