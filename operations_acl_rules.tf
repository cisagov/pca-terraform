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

# Allow ingress from private subnet via VNC
# For: PCA team VNC access from private subnet to operations subnet
resource "aws_network_acl_rule" "operations_ingress_from_private_via_vnc" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "101"
  rule_action    = "allow"
  cidr_block     = aws_subnet.pca_private.cidr_block
  from_port      = 5901
  to_port        = 5901
}

# Allow ingress from anywhere via port 80
# For: PCA target http callbacks to GoPhish server
resource "aws_network_acl_rule" "operations_ingress_from_anywhere_via_http" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "110"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Allow ingress from anywhere via port 443
# For: PCA target https callbacks to GoPhish server
resource "aws_network_acl_rule" "operations_ingress_from_anywhere_via_https" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "111"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Allow ingress from anywhere via lower ephemeral ports (1024-5900)
# We do not want to allow everyone to hit VNC on port 5901
# For: GoPhish fetches resources from https://fonts.googleapis.com
resource "aws_network_acl_rule" "operations_ingress_from_anywhere_via_ports_1024_thru_5900" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "112"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 5900
}

# Allow ingress from anywhere via upper ephemeral ports (5902-65535)
# We do not want to allow everyone to hit VNC on port 5901
# For: GoPhish fetches resources from https://fonts.googleapis.com
resource "aws_network_acl_rule" "operations_ingress_from_anywhere_via_ports_5902_thru_65535" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = false
  protocol       = "tcp"
  rule_number    = "113"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 5902
  to_port        = 65535
}

# Allow egress to anywhere via ephemeral ports
# For: DevOps ssh access from private subnet to operations subnet and
#      PCA team VNC access from private subnet to operations subnet and
#      PCA target callback communication
resource "aws_network_acl_rule" "operations_egress_to_anywhere_via_ephemeral_ports" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "201"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Allow egress to anywhere via SMTP
# For: Postfix in operations subnet to send outbound mail
resource "aws_network_acl_rule" "operations_egress_to_anywhere_via_smtp" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "203"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 25
  to_port        = 25
}

# Allow egress to anywhere via HTTPS
# For: GoPhish fetches resources from https://fonts.googleapis.com
resource "aws_network_acl_rule" "operations_egress_to_anywhere_via_https" {
  network_acl_id = aws_network_acl.pca_operations.id
  egress         = true
  protocol       = "tcp"
  rule_number    = "204"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}
