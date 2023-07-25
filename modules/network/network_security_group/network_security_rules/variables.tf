variable "name" {}
variable "priority" {
  default = 1000
}
variable "direction" {
  default = "Outbound"
}
variable "access" {
  default = "Allow"
}
variable "protocol" {
  default = "Tcp"
}
variable "source_port_range" {
  default = "*"
}
variable "destination_port_range" {
  default = "*"
}
variable "source_address_prefix" {
  default = "*"
}
variable "destination_address_prefix" {
  default = "*"
}
variable "resource_group_name" {}
variable "network_security_group_name" {}
# resource "azurerm_network_security_rule" "example" {
#   name                        = "test123"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.example.name
#   network_security_group_name = azurerm_network_security_group.example.name
# }