# terraform-openstack-openvpn

The repository contains Terraform configurations for deploying the vms necessary for seeing up an openvpn instance on OVH public cloud

In order to run these Terraform configurations you will need to have created an OVH public cloud account, cloud project, Openstack user in the cloud project and downloaded the openrc.sh file for the Openstack user.

You can then source the openrc.sh file you downloaded, provide the password for the Openstack user and run `terraform plan` to test connecting to OVH public cloud.

This Terraform configuration will do the following:
- create an openstack network for internal communication between the certificate authority and openvpn instances
- create an openstack internal subnet for assigning IP addresses to the certificate authority and openvpn instances (10.240.0.0/24)
- create an openstack security group to allow TCP 22 (SSH) and ICMP.
- create a certificate authority instance, install necessary packages (internal address of 10.240.0.101)
- create an openvpn instance, install openvpn packages(internal address of 10.240.0.102)
- add the public IP addresses of the certificate authority and openvpn instances into /etc/hosts (the python openstack client must be installed for this to work - 'pip install python-openstackclient') 

In order to provide seemless SSH access using the /etc/hosts entries the following lines can be added to ~/.ssh/config:

```
Host openvpn-ca
Hostname openvpn-ca
User ubuntu
Port 22
IdentityFile ~/.ssh/id_rsa-terraform_openvpn
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host openvpn-server
Hostname openvpn-server
User ubuntu
Port 22
IdentityFile ~/.ssh/id_rsa-terraform_openvpn
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
```
