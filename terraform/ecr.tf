# Creating an ECR repository
resource "aws_ecr_repository" "workflow_ecr" {
  # Name of the ECR repository. This is passed as a variable.
  name = "${var.project_name}-ecr-repository"

  # Set to IMMUTABLE to ensure that image tags cannot be overwritten.
  image_tag_mutability = "MUTABLE"

  force_delete = true

  # Force delete the repository even if it contains images
  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name  = "${var.project_name}-ecr"
    Owner = local.tags.Owner
    Team  = "Sr. Solutions Architect"
  }

}
