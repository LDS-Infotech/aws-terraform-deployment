aws_region   = "ap-south-1"
environment  = "dev"
project_name = "aws-terraform-deployment"

vpc_id    = "vpc-0b8ab1ceaa4faa925"
subnet_id = "subnet-04e4cf0a233166748"

instance_type    = "t3.micro"
root_volume_size = 20

service_name = "dev-service-ec2"

key_name = "Migration-Key"

ssh_allowed_cidr = "0.0.0.0/0"