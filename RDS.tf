#SUBNET GROUP
resource "aws_db_subnet_group" "wordress-subnet-group" {
  name       = "wordpress-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-a.id, aws_subnet.private-subnet-b.id, aws_subnet.private-subnet-c.id]

  tags = {
    Name = "My DB subnet group"
  }
}


#create Relational Database..


resource "aws_db_instance" "Wordpress-Database" {
  allocated_storage    = 20
  db_name              = "mydb"
  engine               = "mariadb"
  engine_version       = "10.11.6"
  instance_class       = "db.t3.micro"
  username             = "Abiola"
  password             = "Oluwafemi1234"
  skip_final_snapshot  = true
  storage_type         = "gp3"
  deletion_protection = false
  db_subnet_group_name = aws_db_subnet_group.wordress-subnet-group.name
  tags = {
    Name = "wordpress-instance"
  }
}
  





