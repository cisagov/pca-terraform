locals {
  # This is a goofy but necessary way to determine if
  # terraform.workspace contains the substring "prod"
  production_workspace = replace(terraform.workspace, "prod", "") != terraform.workspace

  # Pretty obvious what these are
  tcp_and_udp = [
    "tcp",
    "udp",
  ]
  ingress_and_egress = [
    "ingress",
    "egress",
  ]

  # domain names to use for internal DNS
  pca_private_domain = "pca"
}
