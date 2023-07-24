terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-dev"
    storage_account_name = "stterraformstate07212023"
    container_name       = "terraform"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = var.databricks_host
}