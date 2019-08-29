# Create the IAM instance profile for the Guacamole EC2 server instance

# The instance profile to be used
resource "aws_iam_instance_profile" "guacamole" {
  name = "guacamole_instance_profile_${terraform.workspace}"
  role = aws_iam_role.guacamole_instance_role.name
}

# The instance role
resource "aws_iam_role" "guacamole_instance_role" {
  name               = "guacamole_instance_role_${terraform.workspace}"
  assume_role_policy = "${data.aws_iam_policy_document.guacamole_assume_role_policy_doc.json}"
}

# Attach policies to the instance role
resource "aws_iam_role_policy" "guacamole_access_cert_policy" {
  name   = "access_cert_policy"
  role   = aws_iam_role.guacamole_instance_role.id
  policy = "${data.aws_iam_policy_document.guacamole_read_cert_policy_doc.json}"
}

resource "aws_iam_role_policy" "guacamole_assume_delegated_role_policy" {
  name   = "assume_delegated_role_policy"
  role   = aws_iam_role.guacamole_instance_role.id
  policy = "${data.aws_iam_policy_document.guacamole_assume_delegated_role_policy_doc.json}"
}

################################
# Define the role policies below
################################

data "aws_iam_policy_document" "guacamole_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "guacamole_read_cert_policy_doc" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${local.guacamole_cert_bucket_path_arn}"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "guacamole_assume_delegated_role_policy_doc" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${var.guacamole_cert_read_role_arn}"]
    effect    = "Allow"
  }
}
