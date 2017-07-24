resource "aws_default_vpc" "default_vpc" {
    tags {
        Name = "Default VPC"
    }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-west-2a"

    tags {
        Name = "Default subnet for us-west-2a"
    }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-west-2b"

    tags {
        Name = "Default subnet for us-west-2b"
    }
}

resource "aws_security_group" "ecs_cluster_security_group" {
  name_prefix = "inpa_ecs_cluster_security_group"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    ClusterName = "shared_cluster"
  }
}
