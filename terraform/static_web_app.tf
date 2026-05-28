# Optional Azure Static Web App resources for migration from Storage static website.
resource "azurerm_static_web_app" "portfolio" {
  count               = var.enable_static_web_app ? 1 : 0
  name                = "swa-${local.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_tier            = var.swa_sku_tier
  sku_size            = var.swa_sku_size

  tags = merge(local.tags, {
    Service = "StaticWebApp"
  })
}
