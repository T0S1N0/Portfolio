# DNS Zone (if you want to manage DNS through Azure)
# Note: You'll need to configure your domain registrar to point to Azure DNS nameservers
# Uncomment and configure this section if you want to manage your domain through Azure

# resource "azurerm_dns_zone" "portfolio" {
#   name                = "yourdomain.com"  # Replace with your domain
#   resource_group_name = azurerm_resource_group.main.name
#   
#   tags = local.tags
# }

# # DNS A Record pointing to CDN
# resource "azurerm_dns_a_record" "portfolio" {
#   name                = "@"
#   zone_name           = azurerm_dns_zone.portfolio.name
#   resource_group_name = azurerm_resource_group.main.name
#   ttl                 = 3600
#   target_resource_id  = azurerm_cdn_endpoint.portfolio.id
# }

# # DNS CNAME Record for www subdomain (optional)
# resource "azurerm_dns_cname_record" "portfolio_www" {
#   name                = "www"
#   zone_name           = azurerm_dns_zone.portfolio.name
#   resource_group_name = azurerm_resource_group.main.name
#   ttl                 = 3600
#   record              = azurerm_cdn_endpoint.portfolio.fqdn
# }

# Outputs
# output "dns_zone_id" {
#   value       = azurerm_dns_zone.portfolio.id
#   description = "ID of the DNS zone"
# }

# output "dns_nameservers" {
#   value       = azurerm_dns_zone.portfolio.name_servers
#   description = "Nameservers for the DNS zone"
# }
