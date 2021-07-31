## backend data for terraform
terraform {
  # Terraform version at the time of writing this post
  required_version = ">= 0.12.24"

  backend "s3" {
    bucket = "firstbackendtf"
    key    = "tfbackend_1.tfstate"
    region = "us-east-2"
  }
}

## Provider us-east-1
provider "aws" {
  region     = "us-west-2"  
  alias = "uswest2"
}

resource "aws_instance" "us-west2" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"
  provider = aws.uswest2
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "my-s3-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My terraform bucket"
    Environment = "Dev-Env"
  }
  versioning {
    enabled = true
  }
}

resource "aws_vpc" "dev" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "sub" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dev-subnet"
  }
}

resource "aws_db_instance" "projectdb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.19"
  instance_class       = "db.t3.micro"
  name                 = "myterraformdb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

