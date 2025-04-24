# Route 53 に CloudFront の Aレコードを追加
resource "aws_route53_record" "cloudfront" {
  zone_id = "xxx"
  name    = "xxx.blog"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.my_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
