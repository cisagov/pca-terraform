# Allow ingress from private subnet via ssh
# For: DevOps ssh access from private subnet to operations subnet
resource "aws_network_acl_rule" "operations_ingress_from_private_via_ssh" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "100"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_private.cidr_block
  from_port      = 22
  to_port        = 22
}

# Allow egress to private subnet via ephemeral ports
# For: DevOps ssh access from private subnet to operations subnet
resource "aws_network_acl_rule" "operations_egress_to_private_via_ephemeral_ports" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "101"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_private.cidr_block
  from_port      = 1024
  to_port        = 65535
}

# TODO - ADD:
# Egress to private subnet for remote desktop protocols?
# Ingress from private subnet for remote desktop protocols?
