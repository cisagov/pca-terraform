# cloud-init commands for configuring Guacamole instance

data "template_cloudinit_config" "guacamole_cloud_init_tasks" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "install-certificates.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/install-certificates.tpl.yml", {
        cert_bucket_name   = var.cert_bucket_name
        cert_read_role_arn = var.guacamole_cert_read_role_arn
        server_fqdn        = var.guacamole_fqdn
    })
  }

  part {
    filename     = "setup-guac-connection-sql.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/setup-guac-connection-sql.tpl.yml", {
        aws_region                               = var.aws_region
        guac_connection_setup_filename           = var.guac_connection_setup_filename
        guac_connection_setup_path               = var.guac_connection_setup_path
        guac_gophish_connection_name             = var.guac_gophish_connection_name
        pca_private_domain                       = local.pca_private_domain
        ssm_gophish_vnc_read_role_arn            = var.ssm_gophish_vnc_read_role_arn
        ssm_key_gophish_vnc_password             = var.ssm_key_gophish_vnc_password
        ssm_key_gophish_vnc_user                 = var.ssm_key_gophish_vnc_username
        ssm_key_gophish_vnc_user_private_ssh_key = var.ssm_key_gophish_vnc_user_private_ssh_key
    })
    merge_type = "list(append)+dict(recurse_array)+str()"
  }
}
