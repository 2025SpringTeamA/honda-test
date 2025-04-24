# 簡易的な HTML ファイル（index.html）の作成
resource "local_file" "index_html" {
  content  = "<html><body><h1>React in S3</h1></body></html>"
  filename = "index.html"
}

# index.html を S3 バケットにアップロード
resource "aws_s3_object" "index_file" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = local_file.index_html.filename
  content_type = "text/html"
  acl          = "private"
}
