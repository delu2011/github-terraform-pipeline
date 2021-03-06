#variable "DEPLOY_INTO_ACCOUNT_ID" {
#    type = "string"
#}

#variable "ASSUME_ROLE_EXTERNAL_ID" {
#    type = "string"
#}

variable "AWS_REGION" {
    type = "string"
}

variable "region-ami-map" {
    type = "map"
    default = {
        "us-east-1" = "ami-cd0f5cb6"
        "us-east-2" = "ami-10547475"
        "us-west-1" = "ami-09d2fb69"
        "us-west-2" = "ami-6e1a0117"
        "ca-central-1" = "ami-9818a7fc"
        "eu-central-1" = "ami-1e339e71"
        "eu-west-1" = "ami-785db401"
        "eu-west-2" = "ami-996372fd"
        "ap-southeast-1" = "ami-6f198a0c"
        "ap-southeast-2" = "ami-e2021d81"
        "ap-northeast-1" = "ami-ea4eae8c"
        "ap-northeast-2" = "ami-d28a53bc"
    }
}

provider "aws" {
  region     = "${var.AWS_REGION}"
  version    = "1.54"
#  assume_role {
#    role_arn     = "arn:aws:iam::${var.DEPLOY_INTO_ACCOUNT_ID}:role/TerraformRole"
#    session_name = "Terraform"
#    external_id  = "${var.ASSUME_ROLE_EXTERNAL_ID}"
#  }
}

provider "template" {
  version = "1.0"
}

terraform {
  backend "s3" {
    bucket  = "stage-terraform-backend-terraformstatebucket-1w6taasp55yun"
    key     = "terraform-state"
    region  = "us-east-2"
    encrypt = "true"
  }
}

resource "aws_instance" "ec2instance" {
  ami = "${lookup(var.region-ami-map, var.AWS_REGION)}"
  instance_type = "t2.micro"
}

