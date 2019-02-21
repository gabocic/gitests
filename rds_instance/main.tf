resource "aws_security_group" "instance_sg" {
  name        = "${var.instance_name}"
  description = "allow connections on port 3306"
  vpc_id      = "${var.vpcid}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_db_instance" "master" {
  identifier           		= "${var.instance_name}"
  skip_final_snapshot  		= true
  allocated_storage    		= 5
  storage_type         		= "gp2"
  engine               		= "mysql"
  engine_version       		= "5.7"
  instance_class       		= "db.t2.micro"
  username             		= "foo"
  password             		= "foobarbaz"
  vpc_security_group_ids	= ["${aws_security_group.instance_sg.*.id}"]
  tags                 		= {
                            	environment = "${var.instance_name}"
                         	}
}

resource "aws_db_instance" "replica" {
  identifier           = "${var.instance_name}-replica"
  skip_final_snapshot  = true
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  replicate_source_db  = "${var.instance_name}"
}

provider "mysql" {
    endpoint = "${aws_db_instance.master.endpoint}"
    username = "${var.admin_username}"
    password = "${var.admin_password}"
}

resource "mysql_user" "ro_user" {
  user               = "ro_user"
  host               = "%"
  plaintext_password = "S3Cre7pAss!"
}

resource "mysql_grant" "jdoe" {
  user       = "${mysql_user.ro_user.user}"
  host       = "${mysql_user.ro_user.host}"
  database   = "${var.instance_name}"
  privileges = ["SELECT"]
}

resource "mysql_user" "rw_user" {
  user               = "rw_user"
  host               = "%"
  plaintext_password = "S3Cre7pAss!"
}

resource "mysql_grant" "rw_user" {
  user       = "${mysql_user.rw_user.user}"
  host       = "${mysql_user.rw_user.host}"
  database   = "${var.instance_name}"
  privileges = ["SELECT","UPDATE","DELETE","INSERT"]
}

output "endpoint" {
  value = "${aws_db_instance.master.endpoint}"
}
