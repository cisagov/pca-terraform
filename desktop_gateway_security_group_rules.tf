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
