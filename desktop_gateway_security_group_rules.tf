# Allow ingress from trusted networks via ssh
# For: DevOps ssh access to guacamole instance
# TODO: Modify this access when VPN solution is implemented
resource "aws_security_group_rule" "desktop_gw_ingress_from_trusted_via_ssh" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4
  ipv6_cidr_blocks  = var.trusted_ingress_networks_ipv6
  from_port         = 22
  to_port           = 22
}

# Allow egress via ssh to the gophish instance
# For: DevOps ssh access to gophish instance
resource "aws_security_group_rule" "desktop_gw_egress_to_gophish_via_ssh" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.gophish.private_ip}/32"]
  from_port         = 22
  to_port           = 22
}

# Allow egress via https to anywhere
# For: Guacamole fetches its SSL certificate via boto3 (which uses HTTPS)
resource "aws_security_group_rule" "desktop_gw_egress_to_anywhere_via_https" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
}

# Allow ingress from trusted networks via port 8443 (nginx/guacamole web)
# For: PCA team access to guacamole web client
# TODO: Modify this access when VPN solution is implemented
resource "aws_security_group_rule" "desktop_gw_ingress_from_trusted_via_port_8443" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4
  ipv6_cidr_blocks  = var.trusted_ingress_networks_ipv6
  from_port         = 8443
  to_port           = 8443
}

# Allow egress via VNC to the gophish instance
# For: PCA team VNC access to gophish instance
resource "aws_security_group_rule" "desktop_gw_egress_to_gophish_via_vnc" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.gophish.private_ip}/32"]
  from_port         = 5901
  to_port           = 5901
}

# Allow ingress from anywhere via ephemeral ports below 8443 (1024-8442)
# We do not want to allow everyone to hit Guacamole on port 8443
# For: Guacamole fetches its SSL certificate via boto3 (which uses HTTPS)
resource "aws_security_group_rule" "desktop_gw_ingress_from_anywhere_via_ports_1024_thru_8442" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 1024
  to_port           = 8442
}

# Allow ingress from anywhere via ephemeral ports above 8443 (8444-65535)
# We do not want to allow everyone to hit Guacamole on port 8443
# For: Guacamole fetches its SSL certificate via boto3 (which uses HTTPS)
resource "aws_security_group_rule" "desktop_gw_ingress_from_anywhere_via_ports_8444_thru_65535" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8444
  to_port           = 65535
}
