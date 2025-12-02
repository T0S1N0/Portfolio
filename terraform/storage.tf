# Storage Account for static website hosting
resource "azurerm_storage_account" "portfolio" {
  name                     = "st${replace(local.project_name, "-", "")}${substr(md5(azurerm_resource_group.main.id), 0, 8)}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  tags = local.tags
}

# Enable static website hosting
resource "azurerm_storage_account_static_website" "portfolio" {
  storage_account_id = azurerm_storage_account.portfolio.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

# Blob Container for website files (auto-created by static website, but we reference it for uploads)
resource "azurerm_storage_container" "website" {
  count                 = 0 # Container is auto-created by static website hosting
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.portfolio.name
  container_access_type = "blob"
}

# Upload index.html
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.portfolio.name
  storage_container_name = "$web" # Auto-created by static website hosting
  type                   = "Block"
  source                 = "${path.module}/../index.html"
  content_type           = "text/html"

  depends_on = [azurerm_storage_account_static_website.portfolio]
}

# Upload CV if it exists
resource "azurerm_storage_blob" "cv" {
  count                  = fileexists("${path.module}/../cv.pdf") ? 1 : 0
  name                   = "cv.pdf"
  storage_account_name   = azurerm_storage_account.portfolio.name
  storage_container_name = "$web" # Auto-created by static website hosting
  type                   = "Block"
  source                 = "${path.module}/../cv.pdf"
  content_type           = "application/pdf"

  depends_on = [azurerm_storage_account_static_website.portfolio]
}

# Storage Account Network Rules (Allow all for now, restrict later if needed)
resource "azurerm_storage_account_network_rules" "portfolio" {
  storage_account_id         = azurerm_storage_account.portfolio.id
  default_action             = "Allow"
  bypass                     = ["AzureServices"]
  ip_rules                   = []
  virtual_network_subnet_ids = []
}

# Outputs
output "storage_account_name" {
  value       = azurerm_storage_account.portfolio.name
  description = "Name of the storage account"
}

output "primary_web_endpoint" {
  value       = azurerm_storage_account.portfolio.primary_web_endpoint
  description = "Primary web endpoint of the storage account"
}

output "storage_account_id" {
  value       = azurerm_storage_account.portfolio.id
  description = "ID of the storage account"
}
