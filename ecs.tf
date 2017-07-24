
resource "aws_ecs_cluster" "shared_cluster" {
    name = "shared_cluster"
}

resource "aws_ecr_repository" "inpa_nginx" {
  name = "inpa-nginx"
}

resource "aws_ecr_repository" "inpa_wp" {
  name = "inpa-wp"
}
