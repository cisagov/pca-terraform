variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-east-1"
}

variable "aws_availability_zone" {
  description = "The AWS availability zone to deploy into (e.g. a, b, c, etc.)."
  default     = "a"
}

variable "cert_bucket_name" {
  type        = string
  description = "The name of a bucket that stores certificates. (e.g. my-certs)"
}


variable "dns_role_arn" {
  type        = string
  description = "The ARN of the role that can modify route53 DNS. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS)"
}

variable "guacamole_cert_read_role_arn" {
  type        = string
  description = "A string containing the ARN of a role that can read the Guacamole instance certificate. (e.g. arn:aws:iam::123456789abc:role/ReadCerts)"
}

variable "guacamole_fqdn" {
  type        = string
  description = "A string containing the fully-qualified domain name of the Guacamole instance; it must match the name on the certificate that resides in <cert_bucket_name>. (e.g. guacamole.example.cisa.gov)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created"
  default     = {}
}

# This should be overridden by a production.tfvars file,
# most likely stored outside of version control
variable "trusted_ingress_networks_ipv4" {
  type        = list(string)
  description = "IPv4 CIDR blocks from which to allow ingress to the desktop gateway"
  default     = ["0.0.0.0/0"]
}

variable "trusted_ingress_networks_ipv6" {
  type        = list(string)
  description = "IPv6 CIDR blocks from which to allow ingress to the desktop gateway"
  default     = ["::/0"]
}

variable "create_pca_flow_logs" {
  type        = bool
  description = "Whether or not to create flow logs for the PCA VPC."
  default     = false
}
