module "databricks-resource-group" {
  source = "./modules/resource-group"

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


# Databricks

# Workspace
module "workspace" {
  source = "./modules/databricks/workspace"

  name                = "adb-myapp-dev-eastus2-01"
  location            = "eastus2"
  resource_group_name = module.databricks-resource-group.resource_group_name
  sku                 = "standard"
}