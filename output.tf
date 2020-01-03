output "ansible-master" {
  value = aws_instance.ansible-master.public_ip
}

output "ansible-nodes" {
  value = aws_instance.ansible-slaves.*.public_ip
}