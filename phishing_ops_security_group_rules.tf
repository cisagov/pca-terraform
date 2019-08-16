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

# Allow ingress from guacamole instance via VNC
# For: PCA team VNC access from guacamole instance to phishing ops instance
resource "aws_security_group_rule" "phishing_ops_ingress_from_guacamole_via_vnc" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.guacamole.private_ip}/32"]
  from_port         = 5901
  to_port           = 5901
}

# Allow ingress from anywhere via HTTP
# For: PCA target http callbacks to GoPhish server
resource "aws_security_group_rule" "phishing_ops_ingress_from_anywhere_via_http" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
}

# Allow ingress from anywhere via HTTPS
# For: PCA target https callbacks to GoPhish server
resource "aws_security_group_rule" "phishing_ops_ingress_from_anywhere_via_https" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
}

# Allow ingress from anywhere via ephemeral ports below 5901 (1024-5900)
# We do not want to allow everyone to hit VNC on port 5901
# For: GoPhish fetches resources from https://fonts.googleapis.com
resource "aws_security_group_rule" "phishing_ops_ingress_from_anywhere_via_ports_1024_thru_5900" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 1024
  to_port           = 5900
}

# Allow ingress from anywhere via ephemeral ports above 5901 (5902-65535)
# We do not want to allow everyone to hit VNC on port 5901
# For: GoPhish fetches resources from https://fonts.googleapis.com
resource "aws_security_group_rule" "phishing_ops_ingress_from_anywhere_ports_5902_thru_65535" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 5902
  to_port           = 65535
}

# Allow egress to anywhere via ephmeral ports
# For: DevOps ssh access from guacamole instance to phishing ops instance and
#      PCA team VNC access from guacamole instance to phishing ops instance and
#      PCA target callback communication
resource "aws_security_group_rule" "phishing_ops_egress_to_anywhere_via_ephemeral_ports" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 1024
  to_port           = 65535
}

# Allow egress to anywhere via SMTP
# For: Postfix on phishing ops instance to send outbound mail
resource "aws_security_group_rule" "phishing_ops_egress_to_anywhere_via_smtp" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 25
  to_port           = 25
}

# Allow egress to anywhere via HTTPS
# For: GoPhish fetches resources from https://fonts.googleapis.com
resource "aws_security_group_rule" "phishing_ops_egress_to_anywhere_via_https" {
  security_group_id = aws_security_group.pca_phishing_ops.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
}
