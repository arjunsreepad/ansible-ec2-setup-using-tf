provider "aws" {
    region = var.region
    access_key = var.access_id
    secret_key = var.secret_key
}


resource "aws_instance" "ansible-slaves" {
    count = 3
    ami           = var.image_id
    instance_type = var.ansible-slave-instance-type
    key_name = var.awsKey
    vpc_security_group_ids = [aws_security_group.ansible-sg.id]
    
    tags = {
        Name = "node-${count.index + 1}"
        type = "ansible-slave"
    }
}

resource "aws_instance" "ansible-master" {
    ami           = var.image_id
    instance_type = var.ansible-master-instance-type
    key_name = var.awsKey
    vpc_security_group_ids = [aws_security_group.ansible-sg.id]
    user_data = "${data.template_file.installansible.rendered}"

    provisioner "local-exec" {
        command = "echo ${join(" ", aws_instance.ansible-slaves.*.id)} >> private_ips.txt"
    }

provisioner "file" {
    source      = "aws-virginia.pem"
    destination = "/home/ec2-user/.ssh/id_rsa"
    connection {
        type     = "ssh"
        user     = "ec2-user"       
        private_key = "${file("${var.awsKey}.pem")}"
        timeout = "2m"
        agent = false
        host = self.public_ip
    }
  }

    tags = {
        Name = "ansible-master"
    }
}

resource "aws_security_group" "ansible-sg" {
  name        = "ansible-sg"
  description = "Ansible SG with port 80 and 22 open"

tags = {
        Name = "ansible-sg"
}
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "template_file" "installansible" {
  template = "${file("userdata.sh")}"
}
