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

output "service_instance_id" {
  description = "DEV service EC2 instance ID"
  value       = aws_instance.service.id
}

output "service_private_ip" {
  description = "DEV service EC2 private IP"
  value       = aws_instance.service.private_ip
}

output "service_instance_arn" {
  description = "DEV service EC2 ARN"
  value       = aws_instance.service.arn
}

output "service_security_group_id" {
  description = "DEV service EC2 security group ID"
  value       = aws_security_group.service.id
}