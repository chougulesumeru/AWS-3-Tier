variable "aws_region" {
   default = "us-east-2"
   type= string
   description = "aws-region for instance"
}

variable "instance_type" {
    default = "t2.medium"
    type="string"
}

variable "key_name" {
    default = null
    type= string
    description = "existing ec2 key-pair"
}