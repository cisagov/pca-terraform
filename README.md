# pca-terraform #

[![Build Status](https://travis-ci.com/cisagov/pca-terraform.svg?branch=develop)](https://travis-ci.com/cisagov/pca-terraform)

This project is used to create an operational Phishing Campaign Assessment
(PCA) environment, containing the following instances:

- [Guacamole](https://github.com/cisagov/guacamole-packer) clientless remote
  desktop gateway
- Phishing campaign assessment operating platform containing
  [GoPhish, Postfix, and MailHog](https://github.com/cisagov/pca-gophish-composition-packer)

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system
- An accessible AWS S3 bucket to store terraform state
- An accessible AWS DynamoDB database to store the terraform state lock
- Access to AWS AMIs for [Guacamole](https://github.com/cisagov/guacamole-packer)
  and [GoPhish / Postfix / MailHog](https://github.com/cisagov/pca-gophish-composition-packer)
- OpenSSL server certificate and private key for the Guacamole instance,
  stored in an accessible AWS S3 bucket; this can be easily created via
  [certboto-docker](https://github.com/cisagov/certboto-docker) or a similar
  tool
- A terraform [variables](variables.tf) file customized for your environment,
  for example:

  ```console
  aws_region                    = "us-east-1"
  aws_availability_zone         = "a"
  cert_bucket_name              = "my-certificates"
  dns_domain                    = "cisa.gov"
  dns_role_arn                  = "arn:aws:iam::111111111111:role/ModifyPublicDNS"
  dns_ttl                       = 60
  guacamole_cert_read_role_arn  = "arn:aws:iam::111111111111:role/ReadCert-guacamole.example.cisa.gov"
  guacamole_fqdn                = "guacamole.example.cisa.gov"
  tags                          = {
        Team        = "CISA - Example"
        Application = "Phishing Campaign Assessment (PCA)"
        Workspace   = "example"
  }
  trusted_ingress_networks_ipv4 = [ "192.168.1.0/24" ]
  ```

## Terraform Variables ##

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| aws_region | The AWS region to deploy into (e.g. us-east-1) | string | us-east-1 | no |
| aws_availability_zone | The AWS availability zone to deploy into (e.g. a, b, c, etc.) | string | a | no |
| cert_bucket_name | The name of a bucket that stores certificates. (e.g. my-certs) | string | | yes |
| cert_read_role_arn | The ARN of the role that can create roles to have read access to the S3 bucket ('cert_bucket_name' above) where certificates are stored. (e.g. arn:aws:iam::123456789abc:role/CreateCertificateReadRoles) | string | | yes |
| create_pca_flow_logs | Whether or not to create flow logs for the PCA VPC. | bool | false | no |
| dns_domain | The domain to use for DNS (e.g. cyber.dhs.gov) | string | | yes |
| dns_role_arn | The ARN of the role that can modify route53 DNS. (e.g. arn:aws:iam::123456789abc:role/ModifyPublicDNS) | string | | yes |
| dns_ttl | The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing. | number | 60 | no |
| guac_cert_read_role_accounts_allowed | List of accounts allowed to access the role that can read certificates from an S3 bucket. | list(string) | `[]` | no |
| guac_connection_setup_filename | The name of the file to create on the Guacamole instance containing SQL instructions to populate any desired Guacamole connections.  NOTE: Postgres processes these files alphabetically, so it's important to name this file so it runs after the file that defines the Guacamole tables and users ('00_initdb.sql'). | string | 01_setup_guac_connections.sql | no |
| guac_connection_setup_path | The desired name of the Guacamole connection to the GoPhish instance | string | GoPhish | no |
| guacamole_fqdn | The fully-qualified domain name of the Guacamole instance; it must match the name on the certificate that resides in <cert_bucket_name>. (e.g. guacamole.example.cisa.gov) | string | | yes |
| local_ec2_profile | The name of a local AWS profile (e.g. in your ~/.aws/credentials) that has permission to terminate and check the status of the PCA EC2 instances. (e.g. terraform-pca-role) | string | | yes |
| ssm_gophish_vnc_read_role_arn | The ARN of a role that can get the SSM parameters for the VNC username, password, and private SSH key used on the GoPhish instance. (e.g. arn:aws:iam::123456789abc:role/ReadGoPhishVNCSSMParameters) | string | | yes |
| ssm_key_gophish_vnc_password | The AWS SSM parameter that contains the password needed to connect to the GoPhish instance via VNC (e.g. /vnc/password) | string | | yes |
| ssm_key_gophish_vnc_username | The AWS SSM parameter that contains the username of the VNC user on the GoPhish instance (e.g. /vnc/username) | string | | yes |
| ssm_key_gophish_vnc_user_private_ssh_key | The AWS SSM parameter that contains the private SSH key of the VNC user on the GoPhish instance (e.g. /vnc/ssh_private_key) | string | | yes |
| tf_role_arn | The ARN of the role that can terraform resources. (e.g. arn:aws:iam::123456789abc:role/TerraformPCA) | string | | yes |
| tags | Tags to apply to all AWS resources created | map(string) | `{}` | no |
| trusted_ingress_networks_ipv4 | IPv4 CIDR blocks from which to allow ingress to the desktop gateway | list(string) | `["0.0.0.0/0"]` | no |
| trusted_ingress_networks_ipv6 | IPv6 CIDR blocks from which to allow ingress to the desktop gateway | list(string) | `["::/0"]` | no |

## Setting up the Terraform AWS S3 backend ##

Modify the following parameters in [terraform.tf](terraform.tf) to match
your environment:

- `bucket`: The name of your S3 bucket for storing terraform state
- `dynamodb_table`: The name of your DynamoDB table for storing the terraform
  state lock
- `profile`: The name of a local AWS profile (e.g. in `~/.aws/credentials`)
  that has the permissions below for the bucket and table above:

  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::your-terraform-state-bucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::your-terraform-state-bucket/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:DeleteItem"
            ],
            "Resource": "arn:aws:dynamodb:*:123456789abc:table/your-dynamodb-table"
        }
    ]
  }
  ```

NOTE: The bucket and table above must be created prior to running
`terraform init` in the next step.

## Building the Terraform-based infrastructure ##

```console
# Initial setup only:
terraform workspace create <your_workspace>
terraform init

# After initial setup:
terraform workspace select <your_workspace>
terraform apply -var-file=<your_tf_variables_file>
```

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
