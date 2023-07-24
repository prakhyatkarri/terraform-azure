resource "azurerm_subnet" "subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = var.service_endpoints

  delegation {
    name = var.delegation_name

    service_delegation {
      name    = var.service_delegation_name
      actions = var.service_delegation_actions
    }
  }
}