resource "azurerm_resource_group" "cl1" {
  name     = "cl1"
  location = "eastus"
}

resource "azurerm_cosmosdb_account" "db" {
  name = "wolkcosmosdb"
  location = azurerm_resource_group.cl1.location
  resource_group_name = azurerm_resource_group.cl1.name
  offer_type = "Standard"
  kind = "GlobalDocumentDB"

  consistency_policy {
      consistency_level = "Session"
  }

  geo_location {
    location = azurerm_resource_group.cl1.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name = "ToDoList"
  resource_group_name = azurerm_resource_group.cl1.name
  account_name = azurerm_cosmosdb_account.db.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
  name = "Items"
  resource_group_name = azurerm_resource_group.cl1.name
  account_name = azurerm_cosmosdb_account.db.name
  database_name = azurerm_cosmosdb_sql_database.db.name
  partition_key_path = "/category"
  throughput = 400
}
