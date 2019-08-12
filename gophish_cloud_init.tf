# cloud-init commands for configuring gophish data volume

data "template_file" "gophish_disk_setup" {
  template = file("${path.module}/disk_setup.sh")

  vars = {
    num_disks     = 2
    device_name   = "/dev/xvdb"
    mount_point   = "/var/pca/pca-gophish-composition/data"
    label         = "gophish"
    fs_type       = "ext4"
    mount_options = "defaults"
  }
}

data "template_file" "gophish_dir_setup" {
  template = file("${path.module}/gophish_dir_setup.sh")

  vars = {
    gophish_data_dir = "/var/pca/pca-gophish-composition/data"
  }
}

data "template_cloudinit_config" "gophish_cloud_init_tasks" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.gophish_disk_setup.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.gophish_dir_setup.rendered
  }
}
