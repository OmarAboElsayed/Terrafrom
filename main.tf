module "dev-vpc" {
source = "./vpc"
vpc_cidr = "10.0.0.0/16"
}
resource "aws_security_group" "http-allowed" {
    vpc_id = module.dev-vpc.vpc_id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "http-allowed"
    }
}
module "public-subnet-z1" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.0.0/24"
  zone = "us-east-1a"
  subtype = "true"
}
module "private-subnet-z1" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.1.0/24"
  zone = "us-east-1a"
  subtype = "false"
}
module "networkconf" {
  source = "./Nat_Gataaway"
  aws_vpc_id = module.dev-vpc.vpc_id
  aws_subnet-public-1 = module.public-subnet-z2.subnet_id
}
module "network-z1" {
  source = "./network"
  aws_vpc_id = module.dev-vpc.vpc_id
  aws_internet_gateway = module.networkconf.aws_internet_gateway_id
  aws_nat_gateway = module.networkconf.aws_nat_gateway_id
  aws_subnet-public-1 = module.public-subnet-z1.subnet_id
  destination_cidr_block = "0.0.0.0/0"
  aws_subnet-private-1 = module.private-subnet-z1.subnet_id
}
module "public-subnet-z2" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.2.0/24"
  zone = "us-east-1b"
  subtype = "true"
}
module "private-subnet-z2" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.3.0/24"
  zone = "us-east-1b"
  subtype = "false"
}
module "network-z2" {
  source = "./network"
  aws_vpc_id = module.dev-vpc.vpc_id
  aws_internet_gateway = module.networkconf.aws_internet_gateway_id
  aws_nat_gateway = module.networkconf.aws_nat_gateway_id
  aws_subnet-public-1 = module.public-subnet-z2.subnet_id
  destination_cidr_block = "0.0.0.0/0"
  aws_subnet-private-1 = module.private-subnet-z2.subnet_id
}

module "lb1" {
  source = "./Ap_LoadBalncer"
  alb_name = "private-lb"
  tg-alb_name ="privet-tg"
  alb_type = true
  security_group = [aws_security_group.http-allowed.id]
  sub_alb_id = [module.private-subnet-z2.subnet_id ,  module.private-subnet-z1.subnet_id]
  vpc_tg_id = module.dev-vpc.vpc_id
}
module "ec2_m1" {
  source = "./ec2"
  instance_type = "t2.micro"
  subnet_pv_id = module.private-subnet-z1.subnet_id
  security_group = [aws_security_group.http-allowed.id]
  subnet_pu_id = module.public-subnet-z1.subnet_id
  dns_alb = module.load_blaancer1.aws_lb_alb_pu

}

module "lb2" {
  source = "./alb"
  alb_name = "public-lb"
  tg-alb_name ="pub-tg"
  alb_type = false
  security_group = [aws_security_group.http-allowed.id]
  sub_alb_id = [module.public-subnet-z2.subnet_id ,  module.public-subnet-z1.subnet_id]
  vpc_tg_id = module.dev-vpc.vpc_id
  
}
module "ec2_m2" {
  source = "./ec2"
  instance_type = "t2.micro"
  subnet_pv_id = module.private-subnet-z2.subnet_id
  security_group = [aws_security_group.http-allowed.id]
  subnet_pu_id = module.public-subnet-z2.subnet_id
  dns_alb = module.load_blaancer2.aws_lb_alb_pu
  
}

# resource "aws_lb_target_group_attachment" "tg-att1" {
#   target_group_arn = module.load_blaancer2.aws_lb_target
#   for_each = tomap({ "key1" = module.ec2_m1.aws_instance_ec2_pu_id , "key2" =module.ec2_m2.aws_instance_ec2_pu_id})
#   target_id = each.key
#   port             = 80
# }
# resource "aws_lb_target_group_attachment" "tg-att2" {
#   target_group_arn = module.load_blaancer1.aws_lb_target
#   for_each = tomap({ "key1" = module.ec2_m1.aws_instance_ec2_pv_id , "key2" = module.ec2_m2.aws_instance_ec2_pv_id})
#   target_id = each.key
#   port             = 80
# }

resource "aws_lb_target_group_attachment" "tg-att1" {

  target_group_arn = module.load_blaancer2.aws_lb_target
  target_id        = module.ec2_m1.aws_instance_ec2_pu_id
  port              = 80
}

resource "aws_lb_target_group_attachment" "tg-att2" {

  target_group_arn = module.load_blaancer2.aws_lb_target
  target_id        = module.ec2_m2.aws_instance_ec2_pu_id
  port              = 80
}

resource "aws_lb_target_group_attachment" "tg-att3" {

  target_group_arn = module.load_blaancer1.aws_lb_target
  target_id        = module.ec2_m1.aws_instance_ec2_pv_id
  port              = 80
}

resource "aws_lb_target_group_attachment" "tg-att4" {

  target_group_arn = module.load_blaancer1.aws_lb_target
  target_id        = module.ec2_m2.aws_instance_ec2_pv_id
  port              = 80
}
