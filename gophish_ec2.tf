# The guacamole AMI
data "aws_ami" "gophish" {
  filter {
    name = "name"
    values = [
      "pca-gophish-hvm-*-x86_64-ebs"
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

# The gophish EC2 instance
resource "aws_instance" "gophish" {
  ami                         = data.aws_ami.gophish.id
  instance_type               = "t3.micro"
  availability_zone           = "${var.aws_region}${var.aws_availability_zone}"
  subnet_id                   = aws_subnet.pca_operations.id
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.pca_phishing_ops.id,
  ]

  tags        = merge(var.tags, map("Name", "GoPhish"))
  volume_tags = merge(var.tags, map("Name", "GoPhish"))
}
