variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "sku" {}
variable "tags" {
  default = {
    Environment = "dev"
  }
}
variable "public_network_access_enabled" {
  default = false
}

variable "no_public_ip" {
  default = true
}
variable "virtual_network_id" {}
variable "public_subnet_name" {}
variable "private_subnet_name" {}
variable "public_subnet_network_security_group_association_id" {}
variable "private_subnet_network_security_group_association_id" {}


