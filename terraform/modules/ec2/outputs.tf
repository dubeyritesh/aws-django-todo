output "ec2_private_ips" {
  value = [for instance in aws_instance.app : instance.private_ip]
}

