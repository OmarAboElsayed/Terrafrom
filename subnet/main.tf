resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc-id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.zone
  map_public_ip_on_launch = var.subtype 
  
}