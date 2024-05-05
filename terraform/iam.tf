// Create a new IAM policy that allows me to push to the ECR repository
resource "aws_iam_policy" "policy-workflow-ecr" {
  name        = "${var.project_name}-policy-ecr-push"
  description = "Allows Github Actions to push to the workflow prefect ECR repository"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Effect   = "Allow"
        Resource = "${aws_ecr_repository.workflow_ecr.arn}*"
      },
      {
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

// Create user that will be used by Github Actions
// Note: AWS Credentials need to be generated after running Terraform for the first time
resource "aws_iam_user" "workflow-ecr-user" {
  name = "${var.project_name}-ecr-github-user"
}

// Attach the policy to the user
resource "aws_iam_user_policy_attachment" "workflow-ecr-user-policy" {
  user       = aws_iam_user.workflow-ecr-user.name
  policy_arn = aws_iam_policy.policy-workflow-ecr.arn
}

// Create a ECR_Repository iam role that will allow the Ec2 instance to pull the image from the ECR repository
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

// Create a policy that allows the Ec2 instance to pull the image from the ECR repository
resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.project_name}-ec2-policy"
  description = "Allows the EC2 instance to interact with different AWS services"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Resource = "${aws_ecr_repository.workflow_ecr.arn}",
        Effect   = "Allow"
      },
      {
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
        Effect   = "Allow"
      },
    ]
  })
}

// Attach the policy to the role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

// Creating an instance profile so the role can be attached to the EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

// Creating Task Exectuion Role for ECS Task Definition
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

// Creating a policy that allows full access to the ECR repository and logs
resource "aws_iam_policy" "ecr_full_access_policy" {
  name        = "${var.project_name}-ecr-full-access-policy"
  description = "Allows full access to ECR repository in the worlflow-prefect project"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Resource = "${aws_ecr_repository.workflow_ecr.arn}",
        Effect   = "Allow"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudwatch_workflow_log_group.arn}*",
        Effect   = "Allow"
      },
      {
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

// Attaching the policy to the ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecr_full_access_policy.arn
}
