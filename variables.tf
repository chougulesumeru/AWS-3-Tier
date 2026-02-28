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
