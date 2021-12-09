variable "k3s_nodes" {
  type = list(object({
    name = string
    shape = string
    image_id = string # https://docs.oracle.com/en-us/iaas/images/ubuntu-2004/
    k3s_role = string
    ocpus = string
    memory_in_gbs = string
    private_ip = string
    boot_volume_size_in_gbs = string
  }))
  default = [
    {
      name = "server-1-arm"
      shape = "VM.Standard.A1.Flex"
      image_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaapzfowmk3dwyurhox53yx4eqkmwourxs2ujxgykiymgsw4xnmmkya" # ARM Ubuntu 20.04
      memory_in_gbs = "12"
      ocpus = "2"
      private_ip = "10.0.0.100"
      boot_volume_size_in_gbs = "50"
      k3s_role = "server"
    },
    {
      name = "agent-1-arm"
      shape = "VM.Standard.A1.Flex"
      image_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaapzfowmk3dwyurhox53yx4eqkmwourxs2ujxgykiymgsw4xnmmkya" # ARM Ubuntu 20.04
      memory_in_gbs = "12"
      ocpus = "2"
      private_ip = "10.0.0.101"
      boot_volume_size_in_gbs = "50"
      k3s_role = "agent"
    },
    {
      name = "agent-2-amd"
      shape = "VM.Standard.E2.1.Micro"
      image_id= "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaadqrjjiunkzkf62ggllx56s3p5775gonlifl74d4ri3bykztb4bha" # AMD Ubuntu 20.04
      memory_in_gbs = "1"
      ocpus = "1"
      private_ip = "10.0.0.102"
      boot_volume_size_in_gbs = "50"
      k3s_role = "agent"
    },
    {
      name = "agent-3-amd"
      shape = "VM.Standard.E2.1.Micro"
      image_id= "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaadqrjjiunkzkf62ggllx56s3p5775gonlifl74d4ri3bykztb4bha" # AMD Ubuntu 20.04
      memory_in_gbs = "1"
      ocpus = "1"
      private_ip = "10.0.0.103"
      boot_volume_size_in_gbs = "50"
      k3s_role = "agent"
    }
  ]
}

variable "compartment_ocid" {

}

variable "tenancy_ocid" {

}

variable "region" {
  default = "<your_region>"
}

variable "user_ocid" {

}

variable "fingerprint" {

}

variable "private_key_path" {

}

variable "availability_domain" {
  default = "<availability_domain>"
}

variable "default_fault_domain" {
  default = "FAULT-DOMAIN-1"
}

variable "fault_domains" {
  type    = list(any)
  default = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]
}

variable "path_to_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "oci_core_vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "oci_core_subnet_cidr10" {
  default = "10.0.0.0/24"
}

variable "oci_core_subnet_cidr11" {
  default = "10.0.1.0/24"
}

variable "k3s_server_private_ip" {
  default = "10.0.0.100"
}

variable "tutorial_tag_key" {
  default = "oracle-tutorial"
}

variable "tutorial_tag_value" {
  default = "k3s-terraform"
}

variable "my_public_ip_address" {
  default = "0.0.0.0/0"
}

variable "k3s_token" {
  default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxx"
}

variable "install_longhorn" {
  default = true
}

variable "longhorn_release" {
  default = "v1.2.2"
}
