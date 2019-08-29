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

# The AWS account ID being used
data "aws_caller_identity" "current" {}
