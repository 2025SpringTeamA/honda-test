# RDS 構成の定義  
# サブネットグループ、Secrets Manager、DB インスタンスの設定

# RDS 用のサブネットグループの定義
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "terraform-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private3.id,
    aws_subnet.private4.id
  ]

  tags = {
    Name = "Terraform-rds-subnet-group"
  }
}

# Secrets Manager に保存する RDS パスワード用のシークレットを作成
resource "aws_secretsmanager_secret" "rds_password_v2" {
  name = "rds_password_v2"
}

# シークレットの初期バージョン（パスワードを定義）
resource "aws_secretsmanager_secret_version" "rds_password_version_v2" {
  secret_id     = aws_secretsmanager_secret.rds_password_v2.id
  secret_string = jsonencode({ password = "mypassword123" })
}

# Secrets Manager からパスワードを取得
data "aws_secretsmanager_secret_version" "rds_password_v2" {
  secret_id  = aws_secretsmanager_secret.rds_password_v2.arn
  depends_on = [aws_secretsmanager_secret_version.rds_password_version_v2]
}

# RDS インスタンスの定義（MySQL 8.0）
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.39"
  instance_class       = "db.t4g.micro"

  # 認証情報
  username = "admin"
  password = jsondecode(data.aws_secretsmanager_secret_version.rds_password_v2.secret_string)["password"]

  # サブネットとセキュリティグループの設定
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  multi_az            = false

  tags = {
    Name = "Terraform-rds-instance"
  }

  # 削除時にスナップショットを作成しない
  skip_final_snapshot = true
}
