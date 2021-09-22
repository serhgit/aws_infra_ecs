resource "aws_iam_role" "ecs_tasks_instance_role2" {
  name = "${var.environment}_${var.cluster}_ecs_tasks_instance_role2"

  path = "/prod_ecs_instace_role2/prod/"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF

 inline_policy {
   name   = "${var.environment}_${var.cluster}_rds_secret_access_s3_access"
   policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = ["ssm:GetParameters", "secretsmanager:GetSecretValue"]
          Resource = "${module.secret_manager.secret_manager_rds_arn}"
        },
        {
          Effect   = "Allow",
          Action   = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"]
          Resource = "*"
        },
        {
          Effect   = "Allow",
          Action   = ["s3:ListBucket","s3:GetObject"]
          Resource = "arn:aws:s3:::${var.environment}-apache-php/*"
        }
      ]
    })
 }
}

