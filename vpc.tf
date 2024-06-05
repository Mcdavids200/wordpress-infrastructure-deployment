# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr-block

  tags = {
    Name = "wordpress-vpc"
  }
}