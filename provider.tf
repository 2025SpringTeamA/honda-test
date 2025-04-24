# AWS プロバイダーの定義  
# Terraform が操作対象とするリージョンを ap-northeast-1（東京）に設定

provider "aws" {
  region = "ap-northeast-1"
}
