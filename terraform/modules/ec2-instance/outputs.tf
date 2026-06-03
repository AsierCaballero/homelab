output "public_ip" {
  value = aws_instance.homelab.public_ip
}

output "instance_id" {
  value = aws_instance.homelab.id
}

output "security_group_id" {
  value = aws_security_group.homelab.id
}
