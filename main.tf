# Configure AWS
provider "aws" {
  region = var.aws_region
  # Our primary provider uses our terraform role
  assume_role {
    role_arn     = var.tf_role_arn
    session_name = "terraform-pca"
  }
}

provider "aws" {
  alias  = "dns"
  region = var.aws_region # route53 is global, but still required by terraform
  assume_role {
    role_arn     = var.dns_role_arn
    session_name = "terraform-pca-dns"
  }
}

provider "aws" {
  alias  = "cert_read_role"
  region = var.aws_region
  assume_role {
    role_arn     = var.cert_read_role_arn
    session_name = "terraform-pca-cert"
  }
}

# The AWS account ID being used
data "aws_caller_identity" "current" {}
