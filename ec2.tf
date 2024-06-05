resource "aws_instance" "wordpress_intance" {
  ami                     = var.ami
  instance_type           = "t2.micro"
  key_name                = "world"
  associate_public_ip_address = "false"
  vpc_security_group_ids = [aws_security_group.allow-loadbalancer.id,aws_security_group.bastian-security.id]
   subnet_id = aws_subnet.private-subnet-a.id

  tags = {
    name = "wordpress instance"
  }
}




resource "aws_instance" "bastian_Host" {
  ami                     = var.ami
  instance_type           = "t2.micro"
  key_name                = "word2"
  subnet_id = aws_subnet.public-subnet-a.id
  vpc_security_group_ids = [aws_security_group.bastian-security.id]
 associate_public_ip_address = "true"
  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
    name = "bastian host"
  }
}


