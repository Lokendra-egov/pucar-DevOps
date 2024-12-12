provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id  = "44e70aaa-6d39-441a-b282-352886e1ede7"
  tenant_id        = "d9818707-5ee8-4cc0-a8c5-af772e06f34e"
  client_id        = "3d809bed-c02d-451c-93fd-6eeb74016066"
  client_secret    = "br38Q~R5qrOr5fc~0jp6D2d~LI_CQdq0hiLxvdAu"
}

resource "azurerm_resource_group" "pucar_resource_group" {
  name     = var.resource_group
  location = var.location
  tags = {
    environment = "${var.environment}"
  }
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_storage_account" "pucar_tfstate" {
  name                            = "tfstate${random_string.resource_code.result}"
  resource_group_name             = var.resource_group
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  blob_properties {
    versioning_enabled = true
  }
  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_container" "pucar_tfstate" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.pucar_tfstate.name
  container_access_type = "private"
}
