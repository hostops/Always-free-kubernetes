[![GitHub issues](https://img.shields.io/github/issues/hostops/always-free-kubernetes)](https://github.com/hostops/always-free-kubernetes/issues)
![GitHub](https://img.shields.io/github/license/hostops/always-free-kubernetes)
[![GitHub forks](https://img.shields.io/github/forks/hostops/always-free-kubernetes)](https://github.com/hostops/always-free-kubernetes/network)
[![GitHub stars](https://img.shields.io/github/stars/hostops/always-free-kubernetes)](https://github.com/hostops/always-free-kubernetes/stargazers)

# Always free  kubernetes
This repository is a fork of https://github.com/garutilorenzo/oracle-cloud-terraform-examples.
Modifications here allow you to also use free arm resources.

Because free storage limit is 200GiB and boot volume should be greater than 50GiB we can have maximum 4 instances. Default configuration is 2 arm and 2 amd instances which allows us to use all of free memory and ocpus.

Deploy Oracle Cloud services using Oracle [always free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) resources

**Note** choose a region with enough ARM capacity

### Important notes

* This is repo shows only how to use terraform with the Oracle Cloud infrastructure and use only the **always free** resources. This examples are **not** for a production environment.
* At the end of your trial period (30 days). All the paid resources deployed will be stopped/terminated
* At the end of your trial period (30 days), if you have a running compute instance it will be stopped/hibernated

### Table of Contents

* [Repository structure](#repository-structure)
* [Requirements](#requirements)
  * [Setup RSA Key](#example-rsa-key-generation)
* [Oracle provider setup](#oracle-provider-setup)
* [Variables](#other-variables-to-adjust)
* [Common resources](#common-resources)
* [Firewall](#firewall)
* [OS](#os)
* [Shape](#shape)
* [Useful documentation](#useful-documentation)

### Repository structure

There are three examples:

* Deploy a [simple compute instance](simple-instance/)
* Deploy two instances behind a network load balancer using an [instance pool](instance-pool/)
* Deploy a [k3s-cluster](k3s-cluster/)

### Requirements

To use this repo you will need:

* an Oracle Cloud account. You can register [here](https://cloud.oracle.com)

Once you get the account, follow the *Before you begin* and *1. Prepare* step in [this](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm) document.

#### Example RSA key generation

To use terraform with the Oracle Cloud infrastructure you need to generate an RSA key. Generate the rsa key with:

```
openssl genrsa -out ~/.oci/<your_name>-oracle-cloud.pem 4096
chmod 600 ~/.oci/<your_name>-oracle-cloud.pem
openssl rsa -pubout -in ~/.oci/<your_name>-oracle-cloud.pem -out ~/.oci/<your_name>-oracle-cloud_public.pem
```

replace *<your_name>* with your name or a string you prefer.

**NOTE** ~/.oci/<your_name>-oracle-cloud_public.pem this string will be used on the *terraform.tfvars* used by the Oracle provider plugin, so please take note of this string.

### Oracle provider setup

In any subdirectory of this repo you need to create a terraform.tfvars file, the file will look like:

```
fingerprint      = "<rsa_key_fingerprint>"
private_key_path = "~/.oci/<your_name>-oracle-cloud_public.pem"
user_ocid        = "<user_ocid>"
tenancy_ocid     = "<tenency_ocid>"
compartment_ocid = "<compartment_ocid>"
```

To find your tenency_ocid in the Ocacle Cloud console go to: Governance and Administration > Tenency details, then copy the OCID.

To find you user_ocid in the Ocacle Cloud console go to User setting (click on the icon in the top right corner, then click on User settings), click your username and then copy the OCID

The compartment_ocid is the same as tenency_ocid.

The fingerprint is the fingerprint of your RSA key, you can find this vale under User setting > API Keys

### Other variables to adjust

Before triggering the infrastructure deployment adjust the following variables (vars.tf in each subdirectory):

* region, set the correct region based on your needs
* availability_domain, set you availability domain, you can get the availability domain string in the "*Create instance* form. Once you are in the create instance procedure under the placement section click "Edit" and copy the string that begin with *iAdc:*. Example iAdc:EU-ZURICH-1-AD-1
* default_fault_domain, set de default fault domain, choose one of: FAULT-DOMAIN-1, FAULT-DOMAIN-2, FAULT-DOMAIN-3
* PATH_TO_PUBLIC_KEY, this variable have to point at your ssh public key
* oci_core_vcn_cidr, set the default VCN subnet cidr 
* oci_core_subnet_cidr10, set the default subnet cidr
* oci_core_subnet_cidr11, set the secondary subnet cidr
* tutorial_tag_key, set a key used to tag all the deployed resources
* tutorial_tag_value, set the value of the tutorial_tag_key
* my_public_ip_address, set your public ip address

### Common resources

All the environments share the same network and security list configurations.

The network setup create:

* One VCN (10.0.0.0/16 subnet), you can setup a custom network CIDR in oci_core_vcn_cidr variable.
* Two subnets, the first subnet (default) is the 10.0.0.0/24 range, the second subnet is 10.0.1.0/24 range. You can customize the subnets CIDR in oci_core_subnet_cidr10 and oci_core_subnet_cidr11 variables.

The security list rules are:

* By default only the incoming ICMP, SSH and HTTP traffic is allowed from your public ip. You can setup your public ip in my_public_ip_address variable.
* By default all the outgoing traffic is allowed
* A second security list rule (Custom security list) open all the incoming http traffic
* Both default security list and the custom security list are associated on both subnets
* Network flow from the private VCN subnet is allowed

### Firewall

By default firewall on the compute instances is disabled. On some test the firewall has created some problems

### Software installed

In the simple-instance example and in the instance-pool example nginx will be installed by default.
Nginx is used for testing the security list rules an the correct setup of the Load Balancer (instance-pool example).

On the k3s-cluster example, k3s will be automatically installed on all the machines.

### OS

The operating system used is Ubuntu 20.04

### Shape

All the provisioned instances are VM.Standard.A1.Flex (Arm processor) with 6GB of ram and 1 CPU.

With the Oracle always free you can run 4 VM.Standard.A1.Flex instances for free (24 GB of ram an 4 CPU).

**Note** choose a region with enough ARM capacity

### Useful documentation

Setup the [default vcn resources](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformbestpractices_topic-vcndefaults.htm) documentation.
