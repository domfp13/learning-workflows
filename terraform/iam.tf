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
resource "aws_iam_user" "workflow-ecr-user" {
  name = "${var.project_name}-ecr-github-user"
}

// Attach the policy to the user
resource "aws_iam_user_policy_attachment" "workflow-ecr-user-policy" {
  user       = aws_iam_user.workflow-ecr-user.name
  policy_arn = aws_iam_policy.policy-workflow-ecr.arn
}
