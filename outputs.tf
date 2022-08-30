output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "elastic_public_ip" {
  description = "Elastic Public IP address of the EC2 instance"
  value       = aws_eip.example.public_ip
}