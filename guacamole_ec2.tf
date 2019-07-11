# The guacamole AMI
data "aws_ami" "guacamole" {
  filter {
    name = "name"
    values = [
      "guacamole-hvm-*-x86_64-ebs"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners      = [data.aws_caller_identity.current.account_id] # This is us
  most_recent = true
}

# The guacamole EC2 instance
resource "aws_instance" "guacamole" {
  ami               = data.aws_ami.guacamole.id
  instance_type     = "t3.micro"
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"
  subnet_id         = aws_subnet.pca_private.id
  # TODO: Eventually get rid of public IP address for this instance
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.pca_desktop_gateway.id,
  ]

  tags        = merge(var.tags, map("Name", "Guacamole"))
  volume_tags = merge(var.tags, map("Name", "Guacamole"))
}
