# セキュリティグループの定義  
# ECS、ALB、RDS 用に必要な通信ルールを設定

# ECS 用のセキュリティグループ（アプリケーションの通信を制御）
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id

  # ALB からのリクエストを許可（ポート 1323）
  ingress {
    from_port       = 1323
    to_port         = 1323
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # すべてのアウトバウンドトラフィックを許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-private-instance-sg"
  }
}

# パブリック（ALB）用セキュリティグループ（HTTPS トラフィックを許可）
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main.id

  # インバウンドルール: HTTPS (443) の受信を全インターネットから許可
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # アウトバウンドルール: すべての通信を許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-public-sg"
  }
}

# RDS 用セキュリティグループ（データベースへのアクセスを制御）
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  # インバウンドルール: MySQL (3306) の接続を VPC 内のリソースから許可
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # アウトバウンドルール: すべての通信を許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-rds-sg"
  }
}
