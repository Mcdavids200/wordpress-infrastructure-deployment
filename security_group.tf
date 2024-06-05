
#create security group for loadblancer
resource "aws_security_group" "loadbalancer-allow-http" {
  name        = "allow-http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "loadbalancer-allow_http"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}


#securiy group for wordpress instance
resource "aws_security_group" "allow-loadbalancer" {
  name        = "allow-http-lb"
  description = "Allow http inbound traffic from loadbalancer "
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "lauchtemplate-allow_loadbalancer"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.loadbalancer-allow-http.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "allow-shh" {
  name        = "allow-ssh"
  description = "Allow http inbound traffic from loadbalancer "
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow ssh from bastian host"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastian-security.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

#create security group for bastian host
resource "aws_security_group" "bastian-security" {
  name        = "allow from anywhere"
  description = "Allow http inbound traffic from loadbalancer "
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow any traffic "
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

