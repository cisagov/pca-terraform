# Configure AWS
provider "aws" {
  region = "${var.aws_region}"
}

provider "aws" {
  alias  = "dns"
  region = "${var.aws_region}" # route53 is global, but still required by terraform
  assume_role {
    role_arn     = var.dns_role_arn
    session_name = "terraform-pca-dns"
  }
}

provider "aws" {
  region  = "${var.aws_region}"
  profile = var.cert_read_role_profile
  alias   = "cert_read_role"
}

# The AWS account ID being used
data "aws_caller_identity" "current" {}
