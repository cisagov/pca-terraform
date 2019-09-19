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

variable "cert_read_role_arn" {
  type        = string
  description = "The ARN of the role that can create roles to have read access to the S3 bucket ('cert_bucket_name' above) where certificates are stored. (e.g. arn:aws:iam::123456789abc:role/CreateCertificateReadRoles)"
}

variable "dns_domain" {
  description = "The domain to use for DNS (e.g. cyber.dhs.gov)"
}

variable "dns_role_arn" {
  type        = string
  description = "The ARN of the role that can modify route53 DNS. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS)"
}

variable "dns_ttl" {
  description = "The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing."
  default     = 60
}

variable "guac_cert_read_role_accounts_allowed" {
  type        = list(string)
  description = "List of accounts allowed to access the role that can read certificates from an S3 bucket."
  default     = []
}

variable "guac_connection_setup_filename" {
  type        = string
  description = "The name of the file to create on the Guacamole instance containing SQL instructions to populate any desired Guacamole connections.  NOTE: Postgres processes these files alphabetically, so it's important to name this file so it runs after the file that defines the Guacamole tables and users ('00_initdb.sql')."
  default     = "01_setup_guac_connections.sql"
}

variable "guac_connection_setup_path" {
  type        = string
  description = "The full path to the dbinit directory where <guac_connection_setup_filename> must be stored in order to work properly"
  default     = "/var/guacamole/dbinit"
}

variable "guac_gophish_connection_name" {
  type        = string
  description = "The desired name of the Guacamole connection to the GoPhish instance"
  default     = "GoPhish"
}

variable "guacamole_fqdn" {
  type        = string
  description = "The fully-qualified domain name of the Guacamole instance; it must match the name on the certificate that resides in <cert_bucket_name>. (e.g. guacamole.example.cisa.gov)"
}

variable "local_ec2_profile" {
  type        = string
  description = "The name of a local AWS profile (e.g. in your ~/.aws/credentials) that has permission to terminate and check the status of the PCA EC2 instances. (e.g. terraform-pca-role)"
}

variable "ssm_gophish_vnc_read_role_arn" {
  type        = string
  description = "The ARN of a role that can get the SSM parameters for the VNC username, password, and private SSH key used on the GoPhish instance. (e.g. arn:aws:iam::123456789abc:role/ReadGoPhishVNCSSMParameters)"
}

variable "ssm_key_gophish_vnc_password" {
  type        = string
  description = "The AWS SSM parameter that contains the password needed to connect to the GoPhish instance via VNC (e.g. /vnc/password)"
}

variable "ssm_key_gophish_vnc_username" {
  type        = string
  description = "The AWS SSM parameter that contains the username of the VNC user on the GoPhish instance (e.g. /vnc/username)"
}

variable "ssm_key_gophish_vnc_user_private_ssh_key" {
  type        = string
  description = "The AWS SSM parameter that contains the private SSH key of the VNC user on the GoPhish instance (e.g. /vnc/ssh_private_key)"
}

variable "tf_role_arn" {
  type        = string
  description = "The ARN of the role that can terraform resources. (e.g. arn:aws:iam::123456789abc:role/TerraformPCA)"
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
