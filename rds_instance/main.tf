resource "aws_db_instance" "master" {
  identifier           = "tf-rds-poc"
  skip_final_snapshot  = true
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
}

resource "aws_db_instance" "replica" {
  identifier           = "tf-rds-poc-replica"
  skip_final_snapshot  = true
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  parameter_group_name = "default.mysql5.7"
  replicate_source_db  = "tf-rds-poc"
}
