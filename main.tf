module "databricks-resource-group" {
  source   = "./modules/resource-group"
  name     = "rg-dbx-development-eastus2"
  location = "eastus2"
}

# Networking

module "adb_vnet" {
  source = "./modules/network/virtual_network"
  name   = "vnet-adb"

  location            = "eastus2"
  resource_group_name = module.databricks-resource-group.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = []
  tags                = { Environment = "dev" }
}

module "databricks_public_subnet" {
  source                     = "./modules/network/subnet"
  name                       = "adb_public_subnet_01"
  resource_group_name        = module.databricks-resource-group.resource_group_name
  virtual_network_name       = module.adb_vnet.vnet_name
  address_prefixes           = ["10.0.1.0/24"]
  delegation_name            = "delagation"
  service_delegation_name    = "Microsoft.Databricks/workspaces"
  service_delegation_actions = []
}

module "databricks_private_subnet" {
  source                  = "./modules/network/subnet"
  name                    = "adb_private_subnet_01"
  resource_group_name     = module.databricks-resource-group.resource_group_name
  virtual_network_name    = module.adb_vnet.vnet_name
  address_prefixes        = ["10.0.2.0/24"]
  delegation_name         = "delagation"
  service_delegation_name = "Microsoft.Databricks/workspaces"
  service_delegation_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
}

module "network_security_group" {
  source              = "./modules/network/network_security_group"
  name                = "adb_nsg_01"
  location            = "eastus2"
  resource_group_name = module.databricks-resource-group.resource_group_name
  network_security_rules = [
    {
      name                       = "AllowVirtualNetworkInbound"
      priority                   = "1001"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AzureDatabricksToVirtualNetwork22Inbound"
      priority                   = "1002"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "AzureDatabricks"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AzureDatabricksToVirtualNetwork5557Inbound"
      priority                   = "1003"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5557"
      source_address_prefix      = "AzureDatabricks"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "VirtualNetworkToAzureDatabricks443Outbound"
      priority                   = "1004"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureDatabricks"
    },
    {
      name                       = "VirtualNetworkToAzureSQL3306Outbound"
      priority                   = "1005"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3306"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "SQL"
    },
    {
      name                       = "VirtualNetworkToAzureStorage443Outbound"
      priority                   = "1006"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "Storage"
    },
    {
      name                       = "VirtualNetworkAllOutbound"
      priority                   = "1007"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "VirtualNetworkToEventHub9093Outbound"
      priority                   = "1008"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9093"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "EventHub"
    },
    {
      name                       = "VirtualNetworkToNFS111Outbound"
      priority                   = "1009"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "111"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "NFS"
    },
    {
      name                       = "VirtualNetworkToNFS2049Outbound"
      priority                   = "1010"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "2049"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "NFS"
    }
  ]
}

module "public_subnet_network_security_group_association" {
  source                    = "./modules/network/network_security_group_association"
  subnet_id                 = module.databricks_public_subnet.subnet_id
  network_security_group_id = module.network_security_group.network_security_group_id
}

module "private_subnet_network_security_group_association" {
  source                    = "./modules/network/network_security_group_association"
  subnet_id                 = module.databricks_private_subnet.subnet_id
  network_security_group_id = module.network_security_group.network_security_group_id
}


# Databricks

# Workspace
module "workspace" {
  source = "./modules/databricks/workspace"

  name                                                 = "adb-myapp-dev-eastus2-01"
  location                                             = "eastus2"
  resource_group_name                                  = module.databricks-resource-group.resource_group_name
  sku                                                  = "standard"
  public_subnet_name                                   = module.databricks_public_subnet.subnet_name
  private_subnet_name                                  = module.databricks_private_subnet.subnet_name
  virtual_network_id                                   = module.adb_vnet.vnet_id
  public_subnet_network_security_group_association_id  = module.network_security_group.network_security_group_id
  private_subnet_network_security_group_association_id = module.network_security_group.network_security_group_id
}