
// Output of the EC2 address
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.ec2_worker.public_dns
}

# Outpout the URL of the created ECR repository.
output "repository_uri" {
  description = "The URI of the created ECR repository"
  value       = aws_ecr_repository.workflow_ecr.repository_url
}

# Output the ARN of the created ECR repository.
output "repository_arn" {
  description = "The ARN of the created ECR repository"
  value       = aws_ecr_repository.workflow_ecr.arn
}

# Output the name of the created ECR repository.
output "repository_name" {
  description = "The name of the created ECR repository"
  value       = aws_ecr_repository.workflow_ecr.name
}

# Output the ARN of the cloudwatch log group.
output "cloudwatch_log_group_arn" {
  description = "The ARN of the cloudwatch log group"
  value       = aws_cloudwatch_log_group.cloudwatch_workflow_log_group.arn
}
