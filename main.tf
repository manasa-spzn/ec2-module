#use data block to get ami id dynamically
data "aws_ssm_parameter" "linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}


#create launch templaete for ec2 instances
resource "aws_launch_template" "ec2_launch_template" {
  region        = var.region
  name          = "ec2-launch-template"
  image_id      = data.aws_ssm_parameter.linux_ami.value
  instance_type = "t3.micro"
  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
    http_tokens            = "optional"
  }
  disable_api_termination = false
  disable_api_stop        = false
  vpc_security_group_ids  = [var.ec2_sg_id]
  
  user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>This response is from the private EC2 instance : $(hostname -i)</h1>" > /var/www/html/index.html
                EOF
              )
}

#create auto scaling Group for eC2 instances
resource "aws_autoscaling_group" "ec2_asg" {
  region           = var.region
  name             = "ec2-asg"
  max_size         = 5
  min_size         = 2
  desired_capacity = 2

  vpc_zone_identifier = [
    var.subnet_1_id,
    var.subnet_2_id
  ]

  launch_template {
    id = aws_launch_template.ec2_launch_template.id
  }

  traffic_source {
    identifier = var.alb_target_group_arn
    type       = "elbv2"
  }
}