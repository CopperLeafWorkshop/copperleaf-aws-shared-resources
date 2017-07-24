provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "shared_bucket" {
  bucket = "terraformstate.copperleafsoftwaresolutions.com"
  acl    = "private"
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "copperleaf-aws-shared-resources.tfstate"
  }
}

data "terraform_remote_state" "state" {
  backend  = "s3"
  config {
    bucket = "terraformstate.copperleafsoftwaresolutions.com"
    region = "us-west-2"
    key    = "copperleaf-aws-shared-resources.tfstate"
  }
}
