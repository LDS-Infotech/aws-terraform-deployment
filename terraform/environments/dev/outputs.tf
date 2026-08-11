output "aws_account_id" {
  description = "AWS account ID where Terraform is running"
  value       = local.account_id
}

output "aws_region" {
  description = "AWS deployment region"
  value       = var.aws_region
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}