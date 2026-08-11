variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 20
}

variable "key_name" {
  description = "Existing EC2 key pair name used for SSH"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to access SSH"
  type        = string
}

variable "service_name" {
  description = "Name of the service EC2 instance"
  type        = string
  default     = "service"
}