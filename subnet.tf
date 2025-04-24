# サブネットの定義  
# パブリックおよびプライベートサブネットを AZ ごとに設定

# パブリックサブネット（AZ: ap-northeast-1a）
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "Terraform-subnet-public1-ap-northeast-1a"
  }
}

# パブリックサブネット（AZ: ap-northeast-1c）
resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "Terraform-subnet-public2-ap-northeast-1c"
  }
}

# プライベートサブネット（AZ: ap-northeast-1a）
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "Terraform-subnet-private1-ap-northeast-1a"
  }
}

# プライベートサブネット（AZ: ap-northeast-1c）
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "Terraform-subnet-private2-ap-northeast-1c"
  }
}

# プライベートサブネット（AZ: ap-northeast-1a, 別のCIDRブロック）
resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.160.0/20"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "Terraform-subnet-private3-ap-northeast-1a"
  }
}

# プライベートサブネット（AZ: ap-northeast-1c, 別のCIDRブロック）
resource "aws_subnet" "private4" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.176.0/20"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "Terraform-subnet-private4-ap-northeast-1c"
  }
}
