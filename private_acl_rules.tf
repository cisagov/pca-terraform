# Allow ingress from anywhere via ssh
# Ingress is further restricted to only trusted networks via
# the desktop gateway security group
# For: DevOps ssh access to private subnet
# TODO: Modify this access when VPN solution is implemented
resource "aws_network_acl_rule" "private_ingress_from_anywhere_via_ssh" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "100"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Allow egress to anywhere via HTTPS
# For: Guacamole fetches its SSL certificate via boto3 (which uses HTTPS)
resource "aws_network_acl_rule" "private_egress_to_anywhere_via_https" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "101"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Allow egress to anywhere via ephemeral ports
# For: DevOps ssh access to private subnet
resource "aws_network_acl_rule" "private_egress_to_anywhere_via_ephemeral_ports" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "102"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Allow egress to operations subnet via ssh
# For: DevOps ssh access from private subnet to operations subnet
resource "aws_network_acl_rule" "private_egress_to_operations_via_ssh" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "103"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_operations.cidr_block
  from_port      = 22
  to_port        = 22
}

# Allow ingress from operations subnet via ephemeral ports
# For: DevOps ssh access from private subnet to operations subnet and
#      PCA team VNC access from private subnet to operations subnet
resource "aws_network_acl_rule" "private_ingress_from_operations_via_ephemeral_ports" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "104"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_operations.cidr_block
  from_port      = 1024
  to_port        = 65535
}

# Allow ingress from anywhere via ephemeral ports
# Ingress is further restricted to only trusted networks via
# the desktop gateway security group
# For: PCA team access to guacamole web client
#      Guacamole fetches its SSL certificate via boto3 (which uses HTTPS)
# TODO: Modify this access when VPN solution is implemented
resource "aws_network_acl_rule" "private_ingress_from_anywhere_via_ephemeral_ports" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "110"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Allow egress to operations subnet via VNC
# For: PCA team VNC access from private subnet to operations subnet
resource "aws_network_acl_rule" "private_egress_to_operations_via_vnc" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "120"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_operations.cidr_block
  from_port      = 5901
  to_port        = 5901
}
