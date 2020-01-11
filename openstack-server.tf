resource "openstack_compute_instance_v2" "openvpn-server" {
  name            = "openvpn-server"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${data.openstack_compute_keypair_v2.deploy-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform-openvpn-allow-external.name}"]
  user_data       = templatefile("${path.module}/cloud-init.tpl", { private_ip = "10.240.0.102" })

  network {
    name = "Ext-Net",
  }

  network {
    name = "${data.openstack_networking_network_v2.infra-internal.name}"
    fixed_ip_v4 = "10.240.0.102"
  }

  metadata {
    terraform-openvpn = "openvpn-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/01-ens4.yaml /etc/netplan/01-ens4.yaml",
      "sudo netplan apply",
    ]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }
}

