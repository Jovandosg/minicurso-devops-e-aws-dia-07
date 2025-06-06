variable "authentication" {
  type = object({
    assume_role_arn = string
    region          = string
  })

  default = {
    assume_role_arn = "arn:aws:iam::968225077300:role/LiveMiniCursoDevOpsAWSRole"
    region          = "us-west-1"
  }
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "mini-curso-devops-aws"
  }
}

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })

  default = {
    name                     = "mini-curso-devops-aws-vpc"
    cidr_block               = "10.0.0.0/24"
    internet_gateway_name    = "mini-curso-devops-aws-internet-gateway"
    nat_gateway_name         = "mini-curso-devops-aws-nat-gateway"
    public_route_table_name  = "mini-curso-devops-aws-public-route-table"
    private_route_table_name = "mini-curso-devops-aws-private-route-table"
    public_subnets = [
      {
        name                    = "mini-curso-devops-aws-vpc-public-subnet-1a"
        cidr_block              = "10.0.0.0/26"
        availability_zone       = "us-west-1a"
        map_public_ip_on_launch = true
      },
      {
        name                    = "mini-curso-devops-aws-vpc-public-subnet-1c"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-west-1c"
        map_public_ip_on_launch = true
      }
    ]
    private_subnets = [
      {
        name                    = "mini-curso-devops-aws-vpc-private-subnet-1a"
        cidr_block              = "10.0.0.128/26"
        availability_zone       = "us-west-1a"
        map_public_ip_on_launch = false
      },
      {
        name                    = "mini-curso-devops-aws-vpc-private-subnet-1c"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-west-1c"
        map_public_ip_on_launch = false
      }
    ]
  }
}

variable "eks_cluster" {
  type = object({
    name                              = string
    role_name                         = string
    version                           = string
    enabled_cluster_log_types         = list(string)
    access_config_authentication_mode = string
    node_group_role_name              = string
    node_group_name                   = string
    node_group_instance_types         = list(string)
    node_group_capacity_type          = string
    scaling_config_desired_size       = number
    scaling_config_max_size           = number
    scaling_config_min_size           = number
  })
  default = {
    name                              = "mini-curso-devops-aws-eks-cluster"
    role_name                         = "MiniCursoDevOpsAwsEksClusterRole"
    version                           = "1.33"
    enabled_cluster_log_types         = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    access_config_authentication_mode = "API_AND_CONFIG_MAP"
    node_group_role_name              = "MiniCursoDevOpsAwsEksNodeGroupRole"
    node_group_name                   = "node-group"
    node_group_instance_types         = ["t3.medium"]
    node_group_capacity_type          = "ON_DEMAND"
    scaling_config_desired_size       = 2
    scaling_config_max_size           = 2
    scaling_config_min_size           = 2
  }
}

variable "ecr_repositories" {
  type = list(object({
    name                 = string
    image_tag_mutability = string
    force_delete         = bool
  }))
  default = [
    {
      name                 = "minicursodevopsaws/production/frontend"
      image_tag_mutability = "MUTABLE"
      force_delete         = true
    },
    {
      name                 = "minicursodevopsaws/production/backend"
      image_tag_mutability = "MUTABLE"
      force_delete         = true
    }
  ]
}