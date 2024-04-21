
// Output of the EC2 address
# output "ec2_public_ip" {
#   value = aws_instance.my_ec2.public_dns
# }

# Outpout the URL of the created ECR repository.
output "repository_url" {
  description = "The URL of the created ECR repository"
  value       = aws_ecr_repository.workflow_ecr.repository_url
}

# Output the ARN of the created ECR repository.
output "repository_arn" {
  description = "The ARN of the created ECR repository"
  value       = aws_ecr_repository.workflow_ecr.arn
}
