# ECS 関連リソースの定義  
# クラスター、タスク実行ロール、タスク定義、サービスの構成

# ECS クラスターの定義（Fargate でアプリケーションを実行）
resource "aws_ecs_cluster" "main" {
  name = "my-ecs-cluster"
}

# ECS タスク実行ロールの定義（タスクが必要な AWS サービスへアクセスするための IAM ロール）
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  # ECS タスクがこのロールを引き受けるための信頼ポリシー
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  # タスク実行時に必要な操作を許可するインラインポリシー
  inline_policy {
    name = "ecs-task-execution-policy"

    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "s3:GetObject"
          ],
          Resource = "*"
        }
      ]
    })
  }
}

# ECS タスク定義（Fargate で動作するコンテナの定義）
resource "aws_ecs_task_definition" "main" {
  family                   = "my-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "my-app-repo",
      image = "881490128743.dkr.ecr.ap-northeast-1.amazonaws.com/my-app-repo",
      portMappings = [
        {
          containerPort = 1323,
          hostPort      = 1323,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS サービスの定義（Fargate でアプリケーションを実行し、ALB に登録）
resource "aws_ecs_service" "main" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # サブネットとセキュリティグループの指定（プライベートサブネットで実行）
  network_configuration {
    subnets         = [aws_subnet.private1.id, aws_subnet.private2.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  # ALB にコンテナを登録（ターゲットグループ連携）
  load_balancer {
    target_group_arn = aws_lb_target_group.main_target_group.arn
    container_name   = "my-app-repo"
    container_port   = 1323
  }
}
