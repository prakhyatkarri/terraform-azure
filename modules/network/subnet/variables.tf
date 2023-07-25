variable "name" {}
variable "virtual_network_name" {}
variable "resource_group_name" {}
variable "address_prefixes" {}
variable "delegation_name" {}
variable "service_delegation_name" {}
variable "service_delegation_actions" {}
variable "service_endpoints" {
  default = null
}
