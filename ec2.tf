resource "aws_launch_configuration" "ecs_ec2_launch_configuration" {
  lifecycle {
    create_before_destroy = true
  }
  key_name                    = "${aws_key_pair.container_access_key_pair.key_name}"
  image_id                    = "ami-57d9cd2e"
  instance_type               = "t2.micro"
  security_groups             = ["${aws_security_group.ecs_cluster_security_group.id}"]
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_ec2_profile.name}"
  associate_public_ip_address = true

}

resource "aws_autoscaling_group" "ecs_ec2_autoscaling_group" {
  name                 = "inpa_ecs_ec2_autoscaling_group"
  availability_zones   = ["${split(",", var.availability_zones)}"]
  launch_configuration = "${aws_launch_configuration.ecs_ec2_launch_configuration.name}"
  vpc_zone_identifier  = ["${aws_default_subnet.default_az1.id}","${aws_default_subnet.default_az2.id}"]
  min_size             = 1
  max_size             = 10

   tag {
    key                 = "ClusterName"
    value               = "shared_cluster"
    propagate_at_launch = true
  }
}

/**
* Scale Down 
*/

resource "aws_autoscaling_policy" "ecs_ec2_autoscaling_policy_decrease" {
  name                   = "inpa_ecs_ec2_autoscaling_policy_decrease"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_ec2_autoscaling_group.name}"
}

resource "aws_cloudwatch_metric_alarm" "ecs_ec2_allocation_overallocated_alarm" {
  alarm_name          = "ecs_ec2_allocation_overallocated_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUReservation"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "15"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_ec2_autoscaling_group.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.ecs_ec2_autoscaling_policy_decrease.arn}"]
}


/**
* Scale Up 
*/

resource "aws_autoscaling_policy" "ecs_ec2_autoscaling_policy_increase" {
  name                   = "inpa_ecs_ec2_autoscaling_policy_increase"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_ec2_autoscaling_group.name}"
}

resource "aws_cloudwatch_metric_alarm" "ecs_ec2_allocation_overutilized_alarm" {
  alarm_name          = "ecs_ec2_allocation_overutilized_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUReservation"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_ec2_autoscaling_group.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.ecs_ec2_autoscaling_policy_increase.arn}"]
}


data "template_file" "user_data" {
  template = "${file("./ec2-scripts/userdata.sh")}"
}

resource "aws_key_pair" "container_access_key_pair" {
  key_name   = "informed-parents-uswest2"
  public_key = "${file("./keys/informed-parents-uswest2.pub")}" 
}


/**
* Permissions 
*/


resource "aws_iam_instance_profile" "ecs_ec2_profile" {
  name  = "inpa_ecs_ec2_profile"
  role = "${aws_iam_role.ecs_ec2_role.name}"
}

resource "aws_iam_role" "ecs_ec2_role" {
  name_prefix        = "inpa_ecs_ec2_role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_ec2_role_policy" {
    name_prefix = "inpa_ecs_ec2_role_policy"
    role = "${aws_iam_role.ecs_ec2_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
