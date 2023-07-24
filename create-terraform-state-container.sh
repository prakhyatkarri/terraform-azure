#!/bin/bash

RESOURCE_GROUP_NAME="rg-terraform-dev"
STORAGE_ACCOUNT_NAME="stterraformstate07212023"
CONTAINER_NAME="terraform"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus2

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME