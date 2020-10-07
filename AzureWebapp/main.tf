# Configure the Azure provider
provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "88b7a74c-47d4-48ed-b11f-9bac8f99264c"
  client_id       = "4fe13f05-87c0-4e6e-8e33-3df885a7704e"
  client_secret   = "4d_LfSPBooQdNN~6D8.ysrNpv3zWs-kXP0"
  tenant_id       = "70973106-6728-471c-8ec4-08f6fa9e70bd"
  features {}
}
resource "azurerm_resource_group" "webrg2" {
  name     = "webapprg1"
  location = "eastus"
}

resource "azurerm_app_service_plan" "webplan2" {
  name                = "slotAppServicePlan04"
  location            = azurerm_resource_group.webrg2.location
  resource_group_name = azurerm_resource_group.webrg2.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.webrg2.name
  }

  byte_length = 8
}
resource "azurerm_app_service" "webapp2" {
  name                = "slotAppService400${random_id.randomId.hex}"
  location            = azurerm_resource_group.webrg2.location
  resource_group_name = azurerm_resource_group.webrg2.name
  app_service_plan_id = azurerm_app_service_plan.webplan2.id
}

resource "azurerm_app_service_slot" "slotDemo2" {
    name                = "slotAppServiceSlotOne400${random_id.randomId.hex}"
    location            = azurerm_resource_group.webrg2.location
    resource_group_name = azurerm_resource_group.webrg2.name
    app_service_plan_id = azurerm_app_service_plan.webplan2.id
    app_service_name    = azurerm_app_service.webapp2.name
}
