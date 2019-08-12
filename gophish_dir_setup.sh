#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

# Input variable:
# gophish_data_dir - the directory where the gophish data volume is mounted

# Set group ownership of the gophish data directory to the gophish group
# Ignore this shellcheck: "SC2154: gophish_data_dir is referenced but not
#  assigned." since this variable is passed in from gophish_cloud_init.tf
# shellcheck disable=SC2154
chown --verbose --recursive :gophish "${gophish_data_dir}"

# Give full permissions on the gophish data directory to the gophish group
chmod 775 "${gophish_data_dir}"

# Set the group sticky bit on the gophish data directory so that future
# content in the directory will also be owned by the gophish group
chmod g+s "${gophish_data_dir}"
