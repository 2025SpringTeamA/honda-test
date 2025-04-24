# インターネットゲートウェイ（IGW）の定義  
# VPC に対してインターネットアクセスを提供するための構成

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  # 接続対象の VPC を指定

  tags = {
    Name = "Terraform-igw"  # 識別用のタグを設定
  }
}
