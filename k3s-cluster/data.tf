data "template_cloudinit_config" "k3s_server_tpl" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/files/k3s-install-server.sh", { k3s_token = var.k3s_token, is_k3s_server = true, k3s_url = var.k3s_server_private_ip, install_longhorn = var.install_longhorn, longhorn_release = var.longhorn_release })
  }
}

data "template_cloudinit_config" "k3s_agent_tpl" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/files/k3s-install-agent.sh", { k3s_token = var.k3s_token, is_k3s_server = false, k3s_url = var.k3s_server_private_ip })
  }
}
