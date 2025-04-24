# 変数の定義  
# ACM 証明書の ARN を外部入力として設定

variable "acm_certificate_arn" {
  description = "ARN of the ACM Certificate"
  default     = "arn:aws:acm:ap-northeast-1:881490128743:certificate/d4cd488c-2252-489a-8011-87239ddb1ac7"
}
