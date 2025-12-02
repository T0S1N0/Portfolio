# CDN Profile - DISABLED
# Note: All Azure CDN SKUs (Standard_Akamai, Standard_Verizon, Premium_Verizon, Standard_Microsoft)
# are currently deprecated or not available for new profile creation.
# Using Storage Static Website hosting directly instead.
# Can be re-enabled once Azure CDN API is updated or using Azure Front Door.
#
# resource "azurerm_cdn_profile" "portfolio" {
#   name                = "cdnp-${local.project_name}-${local.environment}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   sku                 = "Premium_Verizon"
#
#   tags = local.tags
# }
#
# resource "azurerm_cdn_endpoint" "portfolio" {
#   name                = "cdn-${local.project_name}-${local.environment}"
#   profile_name        = azurerm_cdn_profile.portfolio.name
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#
#   origin {
#     name       = "storage"
#     host_name  = replace(azurerm_storage_account.portfolio.primary_web_endpoint, "https://", "")
#     https_port = 443
#     http_port  = 80
#   }
#
#   origin_path                   = ""
#   querystring_caching_behaviour = "NotSet"
#   content_types_to_compress     = ["text/plain", "text/html", "text/xml", "text/css", "text/javascript", "application/x-javascript", "application/javascript", "application/json"]
#   is_compression_enabled        = true
#   is_http_allowed               = true
#   is_https_allowed              = true
#
#   tags = local.tags
# }
#
# resource "azurerm_cdn_endpoint_custom_domain" "example" {
#   count           = 0
#   name            = "custom-domain"
#   cdn_endpoint_id = azurerm_cdn_endpoint.portfolio.id
#   host_name       = "your-domain.com"
# }
