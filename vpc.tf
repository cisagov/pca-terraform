# The PCA VPC
resource "aws_vpc" "pca_vpc" {
  cidr_block           = "10.10.50.0/26"
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      "Name" = "Phishing Campaign Assessment"
    },
  )
}

# Setup DHCP so we can resolve our private domain
resource "aws_vpc_dhcp_options" "pca_dhcp_options" {
  domain_name         = local.pca_private_domain
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = merge(
    var.tags,
    {
      "Name" = "Phishing Campaign Assessment"
    },
  )
}

# Associate the DHCP options above with the PCA VPC
resource "aws_vpc_dhcp_options_association" "pca_vpc_dhcp" {
  vpc_id          = aws_vpc.pca_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.pca_dhcp_options.id
}

# Public subnet of the VPC
#
# All external traffic to the private subnet will route through here
# ...EVENTUALLY
# Until our VPN solution is sorted out, external traffic will go directly
# to the private subnet, which will be protected by whitelisted CIDR blocks
# (var.trusted_ingress_networks_ipv4 and var.trusted_ingress_networks_ipv6)
# TODO: Change this when our VPN solution is nailed down
resource "aws_subnet" "pca_public" {
  vpc_id = aws_vpc.pca_vpc.id

  cidr_block        = "10.10.50.0/28"
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"

  depends_on = [aws_internet_gateway.pca_igw]

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Public"
    },
  )
}

# Private subnet of the VPC; for desktop gateway (Guacamole)
resource "aws_subnet" "pca_private" {
  vpc_id            = aws_vpc.pca_vpc.id
  cidr_block        = "10.10.50.16/28"
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"

  depends_on = [aws_internet_gateway.pca_igw]

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Private"
    },
  )
}

# Operations subnet of the VPC
resource "aws_subnet" "pca_operations" {
  vpc_id            = aws_vpc.pca_vpc.id
  cidr_block        = "10.10.50.32/28"
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Operations"
    },
  )
}

# The internet gateway for the VPC
resource "aws_internet_gateway" "pca_igw" {
  vpc_id = aws_vpc.pca_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "PCA IGW"
    },
  )
}

# Default route table for VPC, which routes all external traffic
# through the internet gateway
resource "aws_default_route_table" "pca_default_route_table" {
  default_route_table_id = aws_vpc.pca_vpc.default_route_table_id

  tags = merge(
    var.tags,
    {
      "Name" = "PCA"
    },
  )
}

# Default route: Route all external traffic through the internet
# gateway
resource "aws_route" "pca_default_route_external_traffic_through_internet_gateway" {
  route_table_id         = aws_default_route_table.pca_default_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pca_igw.id
}

# ACL for the public subnet of the VPC
resource "aws_network_acl" "pca_public" {
  vpc_id = aws_vpc.pca_vpc.id
  subnet_ids = [
    aws_subnet.pca_public.id,
  ]

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Public"
    },
  )
}

# ACL for the private subnet of the VPC
resource "aws_network_acl" "pca_private" {
  vpc_id = aws_vpc.pca_vpc.id
  subnet_ids = [
    aws_subnet.pca_private.id,
  ]

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Private"
    },
  )
}

# ACL for the operations subnet of the VPC
resource "aws_network_acl" "pca_operations" {
  vpc_id = aws_vpc.pca_vpc.id
  subnet_ids = [
    aws_subnet.pca_operations.id,
  ]

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Operations"
    },
  )
}

# Security group for the TBD in the public subnet of VPC
# This is a placeholder until the authentication/authorization details
# are sorted out
resource "aws_security_group" "pca_public" {
  vpc_id = aws_vpc.pca_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "PCA TBD"
    },
  )
}

# Security group for the desktop gateway in the private subnet of the VPC
resource "aws_security_group" "pca_desktop_gateway" {
  vpc_id = aws_vpc.pca_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Desktop Gateway"
    },
  )
}

# Security group for the phishing operations instance in the
# operations subnet of the VPC
resource "aws_security_group" "pca_phishing_ops" {
  vpc_id = aws_vpc.pca_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "PCA Phishing Operations"
    },
  )
}
