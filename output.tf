output "shared_tfstate_bucket" {
  value = "${aws_s3_bucket.shared_bucket.bucket}"
}
output "shared_tfstate_region" {
  value = "${aws_s3_bucket.shared_bucket.region}"
}
output "shared_cluster_name" {
  value = "${aws_ecs_cluster.shared_cluster.name}"
}
output "shared_cluster_id" {
  value = "${aws_ecs_cluster.shared_cluster.id}"
}
