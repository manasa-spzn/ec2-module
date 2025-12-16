output "id_asg" {
    description = "The ID of the EC2 Auto Scaling Group"
    value       = aws_autoscaling_group.ec2_asg.id  
}