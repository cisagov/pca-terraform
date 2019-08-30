# Find the public DNS zone for the domain
data "aws_route53_zone" "public_dns_zone" {
  provider = aws.dns
  name     = var.dns_domain
}

resource "aws_route53_record" "guacamole_A" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.public_dns_zone.zone_id
  name     = var.guacamole_fqdn
  type     = "A"
  ttl      = var.dns_ttl
  records  = ["${aws_instance.guacamole.public_ip}"]
}

# Set up private DNS zone and records
resource "aws_route53_zone" "private_dns_zone" {
  name = "${local.pca_private_domain}."

  vpc {
    vpc_id = aws_vpc.pca_vpc.id
  }

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Private Zone"
    },
  )
  comment = "Terraform Workspace: ${terraform.workspace}"
}

resource "aws_route53_record" "private_gophish_A" {
  zone_id = aws_route53_zone.private_dns_zone.zone_id
  name    = "gophish.${aws_route53_zone.private_dns_zone.name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.gophish.private_ip]
}
