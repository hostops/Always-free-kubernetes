resource "oci_network_load_balancer_network_load_balancer" "k3s_load_balancer" {
  depends_on = [
    oci_core_instance.k3s_node
  ]

  compartment_id = var.compartment_ocid
  display_name   = "k3s load balancer"
  subnet_id      = oci_core_subnet.oci_core_subnet11.id

  is_private                     = false
  is_preserve_source_destination = false

  freeform_tags = {
    "${var.tutorial_tag_key}" = "${var.tutorial_tag_value}"
  }
}

resource "oci_network_load_balancer_listener" "k3s_http_listener" {
  depends_on = [
    oci_core_instance.k3s_node,
    oci_network_load_balancer_network_load_balancer.k3s_load_balancer
  ]
  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  name                     = "k3s http listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k3s_load_balancer.id
  port                     = 80
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_listener" "k3s_https_listener" {
  depends_on = [
    oci_core_instance.k3s_node,
    oci_network_load_balancer_network_load_balancer.k3s_load_balancer
  ]
  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  name                     = "k3s https listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k3s_load_balancer.id
  port                     = 443
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "k3s_http_backend_set" {
  depends_on = [
    oci_core_instance.k3s_node,
    oci_network_load_balancer_network_load_balancer.k3s_load_balancer
  ]
  health_checker {
    protocol = "TCP"
    port     = 80
  }

  name                     = "k3s http backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k3s_load_balancer.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = true
}

resource "oci_network_load_balancer_backend_set" "k3s_https_backend_set" {
  depends_on = [
    oci_core_instance.k3s_node,
    oci_network_load_balancer_network_load_balancer.k3s_load_balancer
  ]
  health_checker {
    protocol = "TCP"
    port     = 80
  }

  name                     = "k3s https backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k3s_load_balancer.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = true
}

resource "oci_network_load_balancer_backend" "k3s_http_backend" {
  depends_on = [
    oci_core_instance.k3s_node,
    oci_network_load_balancer_network_load_balancer.k3s_load_balancer
  ]
  count                    = length(oci_core_instance.k3s_node)
  backend_set_name         = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k3s_load_balancer.id
  port                     = 80

  target_id = oci_core_instance.k3s_node[count.index].id
}

resource "oci_network_load_balancer_backend" "k3s_https_backend" {
  depends_on = [
    oci_core_instance.k3s_node,
    oci_network_load_balancer_network_load_balancer.k3s_load_balancer
  ]

  count                    = length(oci_core_instance.k3s_node)
  backend_set_name         = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k3s_load_balancer.id
  port                     = 443
  target_id = oci_core_instance.k3s_node[count.index].id
}
