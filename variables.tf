variable "region" {
    description = "The AWS region to deploy EC2 in - same as vpc"
    type        = string
}

variable "ec2_sg_id" {
    description = "The security group ID for the EC2 instances"
    type        = string
}

variable "subnet_1_id" {
    description = "The ID of the first private subnet to launch EC2 instances in"
    type        = string
}

variable "subnet_2_id" {
    description = "The ID of the second private subnet to launch EC2 instances in"
    type        = string
}

variable "alb_target_group_arn" {
    description = "The ARN of the ALB target group to attach EC2 autoscaling group to"
    type        = string
}