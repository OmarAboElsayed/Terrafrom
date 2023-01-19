resource "aws_instance" "ec2_pv" {
    ami = "ami-0b5eea76982371e91"
    key_name = "iti"
    instance_type = var.instance_type
    subnet_id = var.subnet_pv_id
    vpc_security_group_ids = var.security_group
    user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo systemctl start httpd
        sudo systemctl enable httpd
        sudo sudo chmod 777 /var/www/html/
        sudo echo "<h1>public ip: $(hostname -f)</h1>"> /var/www/html/index.html
        sudo systemctl restart httpd
        EOF

provisioner "local-exec" {
    command = "echo  ${aws_instance.ec2_pv.private_ip} >ips1.txt"
    on_failure = continue
  }
}

resource "aws_instance" "ec2_pu" {
    ami = "ami-0b5eea76982371e91"
    key_name = "iti"
    instance_type = var.instance_type
    subnet_id = var.subnet_pu_id
    vpc_security_group_ids = var.security_group
    provisioner "file" {
    source      = "./file.sh"
    destination = "/home/ec2-user/code.sh"
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("iti.pem")}"
    host = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /home/ec2-user/code.sh",
        ". /home/ec2-user/code.sh",
        "sudo chmod 777 /etc/httpd/conf/httpd.conf",
        "sudo echo '<VirtualHost *:*>' >> /etc/httpd/conf/httpd.conf",
        "sudo echo -e '\t ProxyPreserveHost on' >> /etc/httpd/conf/httpd.conf",
        "sudo echo -e '\t ServerAdmin ec2-user@localhost' >> /etc/httpd/conf/httpd.conf",
        "sudo echo -e '\t ProxyPass / http://${var.dns_alb}/' >> /etc/httpd/conf/httpd.conf",
        "sudo echo -e '\t ProxyPassReverse / http://${var.dns_alb}/' >> /etc/httpd/conf/httpd.conf",
        "sudo echo '</VirtualHost>' >> /etc/httpd/conf/httpd.conf",
        "sudo sleep 5",
        "sudo systemctl restart httpd",
        
    ]
  }
provisioner "local-exec" {
     command = "echo ${aws_instance.ec2_pu.public_ip}>ips2.txt"
       on_failure = continue
   }
}


