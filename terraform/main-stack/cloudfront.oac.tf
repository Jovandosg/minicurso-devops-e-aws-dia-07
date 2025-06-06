resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = aws_s3_bucket.this.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}