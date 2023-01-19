variable "tr_id" {
  type = list
  default = [module.ec2_m1.aws_instance_ec2_pu_id , module.ec2_m2.aws_instance_ec2_pu_id]
}
variable "tr2_id" {
 type = list
 default =  [module.ec2_m1.aws_instance_ec2_pv_id , module.ec2_m2.aws_instance_ec2_pv_id]
}
