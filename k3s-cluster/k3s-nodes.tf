resource "oci_core_instance" "k3s_node" {
  depends_on = [
    oci_core_vcn.default_oci_core_vcn,
    oci_core_subnet.default_oci_core_subnet10,
    oci_core_subnet.oci_core_subnet11,
    oci_core_internet_gateway.default_oci_core_internet_gateway,
    oci_core_default_route_table.default_oci_core_default_route_table,
    data.template_cloudinit_config.k3s_server_tpl,
    data.template_cloudinit_config.k3s_agent_tpl
  ]
  count = length(var.k3s_nodes)

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  fault_domain        = var.default_fault_domain
  
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = oci_core_subnet.default_oci_core_subnet10.id
    private_ip                = var.k3s_nodes[count.index].private_ip
  }

  display_name = var.k3s_nodes[count.index].name

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }

  is_pv_encryption_in_transit_enabled = "true"

  metadata = {
    "ssh_authorized_keys" = file(var.path_to_public_key)
    "user_data"             = var.k3s_nodes[count.index].k3s_role == "server" ? data.template_cloudinit_config.k3s_server_tpl.rendered : data.template_cloudinit_config.k3s_agent_tpl.rendered
  }

  shape = var.k3s_nodes[count.index].shape
  shape_config {
    memory_in_gbs = var.k3s_nodes[count.index].memory_in_gbs
    ocpus         = var.k3s_nodes[count.index].ocpus
  }

  source_details {
    source_id   = var.k3s_nodes[count.index].image_id
    source_type = "image"
    boot_volume_size_in_gbs = var.k3s_nodes[count.index].boot_volume_size_in_gbs
  }

  freeform_tags = {
    "${var.tutorial_tag_key}" = "${var.tutorial_tag_value}"
    "k3s-cluster"             = var.k3s_nodes[count.index].k3s_role
  }
}
