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
    Project     = "live-minicurso-devops-aws"
  }
}

variable "remote_backend" {
  type = object({
    s3_bucket = object({
      name = string
    })

    dynamodb_table = object({
      name         = string
      billing_mode = string
      hash_key     = string
    })
  })

  default = {
    s3_bucket = {
      name = "live-minicurso-devops-aws-remote-backend"
    }

    dynamodb_table = {
      name         = "live-minicurso-devops-aws-remote-backend-locks"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "LockID"
    }
  }
}
