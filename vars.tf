variable "private_key" {
  default = "/root/.ssh/id_rsa-terraform_openvpn"
}

variable "public_key" {
  default = "/root/.ssh/id_rsa-terraform_openvpn.pub"
}

variable "ssh_user" {
  default = "ubuntu"
}

