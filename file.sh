#!/bin/bash# package updates
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/www/html/
sudo echo "<h1>private ip : $(hostname -f)</h1>" > /var/www/html/index.html


