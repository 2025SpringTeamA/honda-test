# S3 バケットおよびファイルアップロードの定義  
# ウェブホスティング設定とバケットポリシーを含めた構成

# S3 バケットの定義（CloudFront 経由でアクセスするためのバケット）
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-cloudfront-bucket-tokyo"
  acl    = "private"

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Production"
  }
}

# バケットのウェブホスティング設定
resource "aws_s3_bucket_website_configuration" "my_bucket_website" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# バケットポリシー（OAI のみアクセス許可）
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.my_oai.iam_arn
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}
