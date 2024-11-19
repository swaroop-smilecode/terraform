resource "aws_instance" "my-ec2-vm" {
  ami           = "ami-047a51fa27710816e" # Amazon Linux
  instance_type = "t2.micro"
  # As of now, just created key pair in the console. Later will create using terraform.
  key_name               = "ec2-key-pair"
  subnet_id              = aws_subnet.vpc-dev-public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.dev-vpc-sg.id]
  tags = {
    "Name" = "myec2vm"
  }
  #user_data = file("apache-install.sh")
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Hello, green trees, cool rains</h1>" > /var/www/html/index.html
    EOF 
}
