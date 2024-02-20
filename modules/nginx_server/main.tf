resource "aws_instance" "server" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  tags = {
    Name = "test-instance"
  }
  user_data = <<-EOF
              #!/bin/bash
              amazon-linux-extras install -y nginx1.12
              systemctl start nginx
              EOF
}