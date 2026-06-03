output "instance_public_ip" {
  description = "Public IP of the homelab server"
  value       = module.homelab_server.public_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = module.homelab_server.instance_id
}
