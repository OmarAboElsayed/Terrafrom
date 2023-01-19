output "aws_instance_ec2_pv_id" {
  value = "${aws_instance.ec2_pv.id}"
  
}
output "aws_instance_ec2_pu_id" {
  value = "${aws_instance.ec2_pu.id}"
}
