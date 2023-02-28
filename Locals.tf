provider "aws" {
region = "us-west-1"
}

resource "aws_s3_bucket" "Remote-bucket" {
    bucket = "buket-dynamo-san"

}
ubuntu@ip-172-31-16-62:~/gittrfm$ cat main.tf
locals {
  env = terraform.workspace
  counts = {
    "default" = 1
    "prod"    = 3
    "dev"     = 2
    "test"    = 1
  }

  Instance_names = {
    "default" = "web-default"
    "prod"    = "web-prod"
    "dev"     = "web-dev"
    "test"    = "web-test"
  }

  Instance_types = {
    "default" = "t2.micro"
    "prod"    = "t2.medium"
    "dev"     = "t2.micro"
    "test"    = "t2.small"
  }

  s3_names = {
    "default" = "terra-s3-def-new"
    "prod"    = "terra-s3-prod-new"
    "dev"     = "terra-s3-dev-new"
    "test"    = "terra-s3-test-new"
  }

  Instance_count = lookup(local.counts, local.env)
  Instance_type  = lookup(local.Instance_types, local.env)
  tags           = lookup(local.Instance_names, local.env)

  s3_name = lookup(local.s3_names, local.env)

}

resource "aws_instance" "newEc2" {
  ami           = "ami-0f8ca728008ff5af4"
  instance_type = local.Instance_type
  count         = local.Instance_count
  tags = {
    Name = "${local.tags}-${count.index}"
  }
}

resource "aws_s3_bucket" "Remote-bucket" {
  bucket = local.s3_name
}
