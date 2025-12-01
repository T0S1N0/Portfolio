# CDN Profile
resource "azurerm_cdn_profile" "portfolio" {
  name                = "cdnp-${local.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Premium_Verizon"

  tags = local.tags
}

# CDN Endpoint
resource "azurerm_cdn_endpoint" "portfolio" {
  name                = "cdn-${local.project_name}-${local.environment}"
  profile_name        = azurerm_cdn_profile.portfolio.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  origin {
    name       = "storage"
    host_name  = replace(azurerm_storage_account.portfolio.primary_web_endpoint, "https://", "")
    https_port = 443
    http_port  = 80
  }

  origin_path                   = ""
  querystring_caching_behaviour = "NotSet"
  content_types_to_compress     = ["text/plain", "text/html", "text/xml", "text/css", "text/javascript", "application/x-javascript", "application/javascript", "application/json"]
  is_compression_enabled        = true
  is_http_allowed               = true
  is_https_allowed              = true

  tags = local.tags
}

# CDN Endpoint Custom Domain (if you have one)
# Uncomment and modify with your domain
# resource "azurerm_cdn_endpoint_custom_domain" "portfolio" {
#   name            = "cdn-custom-${local.project_name}"
#   cdn_endpoint_id = azurerm_cdn_endpoint.portfolio.id
#   host_name       = "your-domain.com"
# }

# Cache expiration rule
resource "azurerm_cdn_endpoint_custom_domain" "example" {
  count           = 0 # Disabled by default, enable if you have a custom domain
  name            = "custom-domain"
  cdn_endpoint_id = azurerm_cdn_endpoint.portfolio.id
  host_name       = "your-domain.com" # Replace with your domain
}

# Outputs
output "cdn_endpoint_fqdn" {
  value       = azurerm_cdn_endpoint.portfolio.fqdn
  description = "FQDN of the CDN endpoint"
}

output "cdn_endpoint_hostname" {
  value       = azurerm_cdn_endpoint.portfolio.fqdn
  description = "Hostname of the CDN endpoint"
}

output "cdn_profile_id" {
  value       = azurerm_cdn_profile.portfolio.id
  description = "ID of the CDN profile"
}
