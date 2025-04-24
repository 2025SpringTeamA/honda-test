# CloudFront ディストリビューションの定義  
# OAI（オリジンアクセスアイデンティティ）を使用して、S3 バケットへのセキュアなアクセスを構成

# CloudFront OAI の定義
resource "aws_cloudfront_origin_access_identity" "my_oai" {
  comment = "OAI for S3 bucket"
}

# CloudFront ディストリビューションの定義
resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = aws_s3_bucket.my_bucket.bucket_regional_domain_name
    origin_id   = "S3-my-cloudfront-bucket"
    origin_path = "/client"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.my_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for S3 bucket in Tokyo region"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-my-cloudfront-bucket"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:xxx"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  aliases = ["honda333.blog"]

  tags = {
    Name        = "MyCloudFrontDistribution"
    Environment = "Production"
  }
}
