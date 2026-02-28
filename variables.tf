variable "aws_region" {
  default     = "us-east-2"
  type        = string
  description = "aws-region for instance"
}

variable "instance_type" {
  default = "t2.medium"
  type    = string
}

variable "key_name" {
  default     = null
  type        = string
  description = "existing ec2 key-pair"
}

variable "project_name" {
  default     = "webshop"
  type        = string
  description = "project-short-name"
}

variable "environment" {
  default     = "dev"
  type        = string
  description = "dev environment for ec2 instance"
}


variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "vpc cidr block"
}

variable "public_subnet_cidrs" {
  default = ["10.77.10.0/24", "10.77.11.0/24"]
  type    = list(string)
}

variable "private_subnet_cidrs" {
  default = ["10.77.20.0/24", "10.77.21.0/24"]
  type    = list(string)
}
