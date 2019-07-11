# Allow ingress from anywhere via ssh
# Ingress is allowed from trusted networks via
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

# Allow egress to anywhere via ephemeral ports
# For: DevOps ssh access to private subnet
resource "aws_network_acl_rule" "private_egress_to_anywhere_via_ephemeral_ports" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "101"
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
  rule_number    = "102"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_operations.cidr_block
  from_port      = 22
  to_port        = 22
}

# Allow ingress from operations subnet via ephemeral ports
# For: DevOps ssh access from private subnet to operations subnet
resource "aws_network_acl_rule" "private_ingress_from_operations_via_ephemeral_ports" {
  network_acl_id = aws_network_acl.pca_private.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "103"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_operations.cidr_block
  from_port      = 1024
  to_port        = 65535
}

# TODO - ADD:
# Egress to operations subnet for remote desktop protocols?
# Ingress from operations subnet for remote desktop protocols?
