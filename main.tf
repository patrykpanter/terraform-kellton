terraform {
  backend "s3" {
    bucket         = "kellton-ppanter-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform_state_locking"
    encrypt        = true
  }
  required_version = "~> 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}


resource "aws_vpc" "vpc" {
  cidr_block       = "172.16.0.0/22"
  instance_tenancy = "default"

  tags = {
    Name = "recruitment@candidate011"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "recruitment@candidate011-1b"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "eu-north-1c"

  tags = {
    Name = "recruitment@candidate011-1c"
  }
}

resource "aws_route_table" "rt_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "172.16.0.0/22"
    gateway_id = "local"
  }


  tags = {
    Name = "recruitment@candidate011"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "recruitment@candidate011-1c"
  }
}
