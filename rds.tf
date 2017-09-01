resource "aws_db_instance" "shared_db" {  
  allocated_storage        = 10 # gigabytes
  backup_retention_period  = 7   # in days
  engine                   = "mariadb"
  identifier               = "shared-rds"
  instance_class           = "db.t2.small"
  multi_az                 = false
  name                     = "shared_db"
  password                 = "${var.db_password}"
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = true # you should always do this
  storage_type             = "gp2"
  username                 = "shared_db_owner"
  vpc_security_group_ids   = ["${aws_security_group.rds_security_group.id}"]
  skip_final_snapshot      = true
}


resource "aws_security_group" "rds_security_group" {  
  name = "rds_security_group"

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

