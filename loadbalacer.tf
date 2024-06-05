resource "aws_lb" "apache-loadbalancer" {
  name               = "apache-lb-tf"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer-allow-http.id]
  subnets            = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id, aws_subnet.public-subnet-c.id]
  


  tags = {
    Name = "apache-loadbalancer"
  }
}

#apache-target-group

resource "aws_lb_target_group" "apache-targetgroup" {
  name     = "apache-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path     = "/"
    port    = 80
  }

  tags = {
    name = "apache-targetgroup"
  }
}

#apche-listener 
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.apache-loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache-targetgroup.arn
  }
}

