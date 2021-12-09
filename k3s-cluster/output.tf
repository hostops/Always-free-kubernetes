output "k3s_node_private_ip" {
  value = oci_core_instance.k3s_node.*.private_ip
}
output "k3s_node_public_ip" {
  value = oci_core_instance.k3s_node.*.public_ip
}

output "lb_ip" {
  value = oci_network_load_balancer_network_load_balancer.k3s_load_balancer.ip_addresses
}
