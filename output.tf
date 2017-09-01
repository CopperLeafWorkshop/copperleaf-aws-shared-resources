output "shared_tfstate_bucket" {
  value = "${aws_s3_bucket.shared_bucket.bucket}"
}
output "shared_tfstate_region" {
  value = "${aws_s3_bucket.shared_bucket.region}"
}
output "shared_cluster_id" {
  value = "${aws_ecs_cluster.shared_cluster.id}"
}
output "shared_cluster_name" {
  value = "${aws_ecs_cluster.shared_cluster.name}"
}
output "ecs_cluster_security_group_id" {
  value = "${aws_security_group.ecs_cluster_security_group.id}"
}
output "db_address" {
  value = "${aws_db_instance.shared_db.address}"
}
