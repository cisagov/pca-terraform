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
  instance_type               = "t3.small"
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

  user_data_base64 = data.template_cloudinit_config.gophish_cloud_init_tasks.rendered

  tags        = merge(var.tags, map("Name", "GoPhish"))
  volume_tags = merge(var.tags, map("Name", "GoPhish"))
}

# The Elastic IP for the gophish instance
resource "aws_eip" "gophish" {
  vpc  = true
  tags = merge(var.tags, map("Name", "GoPhish EIP"))
}

# The EIP association for the gophish instance
resource "aws_eip_association" "gophish" {
  instance_id   = aws_instance.gophish.id
  allocation_id = aws_eip.gophish.id
}

# Note that the EBS volume contains production data, so we use the
# prevent_destroy lifecycle element to disallow the destruction of it
# via terraform.
resource "aws_ebs_volume" "gophish_data" {
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"
  type              = "gp2"
  size              = 8
  encrypted         = true

  tags = merge(var.tags, map("Name", "GoPhish Data"))

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "gophish_data_attachment" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.gophish_data.id
  instance_id = aws_instance.gophish.id

  skip_destroy = true
  depends_on   = [aws_ebs_volume.gophish_data]
}
