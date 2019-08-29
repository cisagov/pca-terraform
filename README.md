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
