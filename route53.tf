# Find the DNS zone for the domain
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
