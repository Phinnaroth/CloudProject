

resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  db_name              = "todo_app_db"
  username             = "admin"
  password             = "Admin#123"
  parameter_group_name = "default.mysql8.0"
  multi_az             = false
  storage_type         = "gp2"
  publicly_accessible = true
  skip_final_snapshot = true

  tags = {
    Name = "TodoAppDatabase"
  }
}