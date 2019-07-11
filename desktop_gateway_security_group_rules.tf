# Allow ingress from trusted networks via ssh
# For: DevOps ssh access to guacamole instance
# TODO: Modify this access when VPN solution is implemented
resource "aws_security_group_rule" "desktop_gw_ingress_from_trusted_via_ssh" {
  security_group_id = aws_security_group.pca_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4

  # ipv6_cidr_blocks = "${var.trusted_ingress_networks_ipv6}"
  from_port = 22
  to_port   = 22
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

# # Allow guacamole web client ingress from the guacamole instance
# # For: User access to guacamole web docker container
# resource "aws_security_group_rule" "guacamole_client_ingress_from_desktop_gw" {
#   security_group_id = "${aws_security_group.pca_desktop_gateway.id}"
#   type              = "ingress"
#   protocol          = "tcp"
#   cidr_blocks = [
#     "${aws_instance.guacamole.private_ip}/32"
#   ]
#   from_port = 8080
#   to_port   = 8080
# }
#
# # IS THIS NEEDED?
# # Allow guacd ingress from the guacamole instance
# resource "aws_security_group_rule" "guacd_ingress_from_desktop_gw" {
#   security_group_id = "${aws_security_group.playground_private_sg.id}"
#   type              = "ingress"
#   protocol          = "tcp"
#   cidr_blocks = [
#     "${aws_instance.guacamole.private_ip}/32"
#   ]
#   from_port = 4822
#   to_port   = 4822
# }
#
# # Allow ingress via ephemeral ports from the gophish instance
# resource "aws_security_group_rule" "desktop_gw_ingress_from_gophish_via_ephemeral_ports" {
#   security_group_id        = aws_security_group.pca_desktop_gateway.id
#   type                     = "ingress"
#   protocol                 = "tcp"
#   cidr_blocks              = ["${aws_instance.gophish.private_ip}/32"]
#   from_port                = 1024
#   to_port                  = 65535
# }

# TODO - ADD:
# Egress to gophish instance for remote desktop protocols?
# Ingress from gophish instance for remote desktop protocols?
