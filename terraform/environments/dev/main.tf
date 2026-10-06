data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_security_group" "service" {
  name        = "${var.project_name}-${var.environment}-service-sg"
  description = "Security group for DEV service EC2"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-service-sg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.service.id

  cidr_ipv4   = data.aws_vpc.selected.cidr_block
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.service.id

  cidr_ipv4   = var.ssh_allowed_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "Allow SSH from approved source"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.service.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

resource "aws_iam_role" "ec2_ssm" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-ssm-role"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.project_name}-${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm.name
}

resource "aws_instance" "service" {
  ami           = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.selected.id

  vpc_security_group_ids = [
    aws_security_group.service.id
  ]

  key_name = var.key_name

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.service_name}"
    Environment = var.environment
    Project     = var.project_name
    Service     = var.service_name
    ManagedBy   = "Terraform"
    OS          = "Amazon Linux 2023"
    Deployment  = "CI-CD-Fresh-EC2-Test"
  }
}
