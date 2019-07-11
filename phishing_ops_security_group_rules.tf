# Allow ingress from guacamole instance via ssh
# For: DevOps ssh access from guacamole instance to phishing ops instance
resource "aws_security_group_rule" "phishing_ops_ingress_from_guacamole_via_ssh" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.guacamole.private_ip}/32"]
  from_port         = 22
  to_port           = 22
}

# Allow egress to guacamole instance via ephmeral ports
# For: DevOps ssh access from guacamole instance to phishing ops instance
resource "aws_security_group_rule" "phishing_ops_egress_to_guacamole_via_ephemeral_ports" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.guacamole.private_ip}/32"]
  from_port         = 1024
  to_port           = 65535
}
# Allow ingress via ephemeral ports from the gophish instance
# For: ?
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
