provider "aws" {
  region = "us-east-1"
}

# Retrieve the proper machine image for EC2 instance
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# check existing instance count for naming tag
data "aws_instances" "existing_simple_ec2" {
  filter{
    name = "tag:Group"
    values = ["ServiceNow Simple EC2"]
  }
}


locals {
  simple_ec2_count = length(data.aws_instances.existing_simple_ec2.ids)
}


# Create AWS Compute Instance 
resource "aws_instance" "ec2_test" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.nano"
  //instance_type = "t2.nano"

  tags = {
    Name = "EC2 ServiceNow Test ${local.simple_ec2_count +1}"
    Group = "ServiceNow Simple EC2"
  }
}
