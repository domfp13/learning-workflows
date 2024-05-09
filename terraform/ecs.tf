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

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

# ECS task definition
resource "aws_ecs_task_definition" "ecs-task-definition" {
  family = "${var.project_name}-ecs-task-definition"

  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  network_mode = "awsvpc"
  cpu          = "256"
  memory       = "512"

  // Task Execution Role: This role is used by ECS to pull the Docker image for your task from the ECR repository and to send logs to CloudWatch
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  // Task Role: This role is assigned to the task itself. It determines what other AWS service resources the task is allowed to interact with
  //task_role_arn      = aws_iam_role.ecs_task_role.arn

  // Container Definitions  
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "${var.project_name}-ecs-app",
    "image": "${aws_ecr_repository.workflow_ecr.repository_url}:latest",
    "essential": true,

    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],

    "cpu": 256,
    "memory": 512,

    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_workflow_log_group.name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "ecs"        
      }
    }
  }
]
TASK_DEFINITION

  // Tags
  tags = {
    Owner = local.tags.Owner
    Name  = "${var.project_name}-ecs-task-definition"
  }
}

// ECS Service Fargate
# resource "aws_ecs_service" "ecs_service" {
#   name            = "${var.project_name}-ecs-service"
#   cluster         = aws_ecs_cluster.ecs_workflow_cluster.id
#   task_definition = aws_ecs_task_definition.ecs-task-definition.arn
#   desired_count   = 1
#   depends_on      = [aws_iam_role.ecs_task_execution_role]

#   network_configuration {
#     subnets          = [aws_subnet.public_subnet.id]
#     security_groups  = [aws_security_group.my_sg_public.id]
#     assign_public_ip = true
#   }
# }
