resource "azurerm_subnet_network_security_group_association" "pucar_security" {
  subnet_id                 = "${var.subnet_id}"
  network_security_group_id = "${var.network_security_group_id}"
}

resource "azurerm_private_dns_zone" "pucar_dns" {
  name                = "${var.resource_group}-pdz.postgres.database.azure.com"
  resource_group_name = "${var.resource_group}"
}

resource "azurerm_private_dns_zone_virtual_network_link" "pucar_network_link" {
  name                  = "${var.resource_group}-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.pucar_dns.name
  virtual_network_id    = "${var.virtual_network_id}"
  resource_group_name   = "${var.resource_group}"
}

resource "azurerm_postgresql_flexible_server" "pucar_postgres" {
  name                   = "${var.resource_group}-test-server"
  resource_group_name    = "${var.resource_group}"
  location               = "${var.location}"
  version                = "${var.db_version}"
  delegated_subnet_id    = azurerm_subnet_network_security_group_association.pucar_security.id
  private_dns_zone_id    = azurerm_private_dns_zone.pucar_dns.id
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  storage_mb             = "${var.storage_mb}"
  sku_name               = "${var.sku_tier}"
  backup_retention_days  = 7
  zone                   = var.zone
}

resource "azurerm_postgresql_flexible_server_database" "pucar_postgres_db" {
  name      = "${var.resource_group}-db"
  server_id = azurerm_postgresql_flexible_server.pucar_postgres.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_configuration" "pucar_postgres_config" {
  name                = "require_secure_transport"
  server_id         = azurerm_postgresql_flexible_server.pucar_postgres.id
  value               = "off"
}
