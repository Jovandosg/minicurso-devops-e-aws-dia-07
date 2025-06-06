# data "http" "node_pool_crd" {
#   url = "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v1.5.0/pkg/apis/crds/karpenter.sh_nodepools.yaml"
# }

# data "http" "node_class_crd" {
#   url = "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v1.5.0/pkg/apis/crds/karpenter.k8s.aws_ec2nodeclasses.yaml"
# }

# data "http" "node_claim_crd" {
#   url = "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v1.5.0/pkg/apis/crds/karpenter.sh_nodeclaims.yaml"
# }

# resource "kubernetes_manifest" "node_pool_crd" {
#   manifest = yamldecode(data.http.node_pool_crd.response_body)
# }

# resource "kubernetes_manifest" "node_class_crd" {
#   manifest = yamldecode(data.http.node_class_crd.response_body)
# }

# resource "kubernetes_manifest" "node_claim_crd" {
#   manifest = yamldecode(data.http.node_claim_crd.response_body)
# }