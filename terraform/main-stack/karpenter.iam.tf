resource "aws_iam_role" "karpenter_controller" {
  name = "KarpenterControllerRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_url}"
      }
      Condition = {
        StringEquals = {
          "${local.oidc_url}:aud" = "sts.amazonaws.com"
          "${local.oidc_url}:sub" = "system:serviceaccount:kube-system:karpenter"
        }
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "karpenter" {
  name        = "karpenter_policy"
  path        = "/"
  description = "IAM policy for Karpenter functionality"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Karpenter"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ec2:DescribeImages",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts"
        ]
        Resource = "*"
      },
      {
        Sid      = "ConditionalEC2Termination"
        Effect   = "Allow"
        Action   = "ec2:TerminateInstances"
        Resource = "*"
        Condition = {
          StringLike = {
            "ec2:ResourceTag/karpenter.sh/nodepool" = "*"
          }
        }
      },
      {
        Sid      = "PassNodeIAMRole"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = aws_iam_role.eks_node_group.arn
      },
      {
        Sid      = "EKSClusterEndpointLookup"
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = "arn:aws:eks:${var.authentication.region}:${data.aws_caller_identity.current.account_id}:cluster/${aws_eks_cluster.this.id}"
      },
      {
        Sid    = "AllowScopedInstanceProfileCreationActions"
        Effect = "Allow"
        Action = [
          "iam:CreateInstanceProfile"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}" = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                    = "${var.authentication.region}"
          }
          StringLike = {
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid    = "AllowScopedInstanceProfileTagActions"
        Effect = "Allow"
        Action = [
          "iam:TagInstanceProfile"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                    = "${var.authentication.region}"
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}"  = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                     = "${var.authentication.region}"
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"  = "*"
          }
        }
      },
      {
        Sid    = "AllowScopedInstanceProfileActions"
        Effect = "Allow"
        Action = [
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                    = "${var.authentication.region}"
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowInstanceProfileReadActions"
        Effect   = "Allow"
        Action   = "iam:GetInstanceProfile"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_custom_policy" {
  policy_arn = aws_iam_policy.karpenter.arn
  role       = aws_iam_role.karpenter_controller.name
}
