
# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "cloudwatch_workflow_log_group" {
  name              = "${var.project_name}-cloudwatch-logs"
  retention_in_days = 3
}

# ECS cluster
resource "aws_ecs_cluster" "ecs_workflow_cluster" {
  name = "${var.project_name}-ecs-cluster"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.cloudwatch_workflow_log_group.name
      }
    }
  }
}

# ECS capacity provider
resource "aws_ecs_cluster_capacity_providers" "ecs_worflow_capacity" {
  cluster_name = aws_ecs_cluster.ecs_workflow_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 2
    capacity_provider = "FARGATE"
  }
}

# ECS task definition
# resource "aws_ecs_task_definition" "ecs_workflow_task_definition" {
#   family                   = "${var.project_name}-ecs-task-definition"
#   container_definitions    = file("${path.module}/ecs-task-definition.json")
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn
# }