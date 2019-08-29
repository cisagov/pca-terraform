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
}
