provider "azurerm" {
  features {}
  subscription_id = "4793c294-5e3c-47a4-8701-4c1402d8ca81"
  client_id       = "51cc1236-8e75-4084-92d0-6bc320b17c35"
  client_secret   = "gWL7Q~bB8a5ZN.LLVfDeaOsmKHRdSB.2i3kQT"
  tenant_id       = "4f008545-7eb1-44e9-b7f4-ea0f30b4e798"

}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = var.failover_location
    failover_priority = 1
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}