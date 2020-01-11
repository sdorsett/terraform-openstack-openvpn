provider "openstack" {
#  user_name is unset so it defaults to OS_USERNAME environment variable
#  tenant_name is unset so it defaults to OS_TENANT_NAME or OS_PROJECT_NAME environment variable
#  password is unset so it defaults to OS_PASSWORD environment variable
#  auth_url is unset so it defaults to OS_AUTH_URL environment variable
#  region is unset so it defaults to OS_REGION_NAME environment variable
}

data "openstack_compute_keypair_v2" "deploy-keypair" {
  name       = "deploy-keypair"
}

resource "openstack_compute_secgroup_v2" "terraform-openvpn-allow-external" {
  name        = "terraform-openvpn-allow-external"
  description = "permitted inbound external traffic"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

}

data "openstack_images_image_v2" "ubuntu_18_04" {
  name = "Ubuntu 18.04"
  most_recent = true
}

data "openstack_compute_flavor_v2" "s1-2" {
  name = "b2-7"
}

data "openstack_networking_network_v2" "infra-internal" {
  name           = "default-internal"
}

#data "openstack_networking_subnet_v2" "infra-internal-subnet" {
#  name       = "default-internal-subnet"
#  ip_version = 4
#}
