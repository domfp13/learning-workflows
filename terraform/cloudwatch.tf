
# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "cloudwatch_workflow_log_group" {
  name              = "${var.project_name}-cloudwatch-logs"
  retention_in_days = 3
}
