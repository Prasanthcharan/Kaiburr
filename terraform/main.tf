provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

variable "awsprops" {
    type = map
    default = {
    region = "us-east-1"
    vpc = "vpc-09d8c15a1efff0003"
    ami = "ami-016eb5d644c333ccb"
    itype = "t2.micro"
    subnet = "subnet-0bfa20c5d9282dd91"
    publicip = true
    keyname = "devops"
    secgroupname = "IAC-Sec-Group"
  }
}


resource "aws_security_group" "project-iac-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  // To Allow SSH Transport
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")
  user_data = "${file("init.sh")}"
  vpc_security_group_ids = [
    aws_security_group.project-iac-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }

  provisioner "file" {
        source      = "/home/ec2-user/terraform/mongodb-ansible"
        destination = "/home/ec2-user/mongodb-ansible"
     }
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("/home/ec2-user/terraform/files/devops.pem")}"
      host        = "${self.public_ip}"
    }
  tags = {
    Name ="SERVER01"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.project-iac-sg ]
}


output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}
