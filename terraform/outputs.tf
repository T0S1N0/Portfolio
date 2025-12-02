# Main Outputs

output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group"
}

output "resource_group_id" {
  value       = azurerm_resource_group.main.id
  description = "ID of the resource group"
}

output "portfolio_url" {
  value       = azurerm_storage_account.portfolio.primary_web_endpoint
  description = "URL of the portfolio website (Static Website Hosting)"
}

output "storage_website_endpoint" {
  value       = azurerm_storage_account.portfolio.primary_web_endpoint
  description = "Direct URL to the storage account website endpoint"
}

output "deployment_summary" {
  value = {
    storage_account = azurerm_storage_account.portfolio.name
    portfolio_url   = azurerm_storage_account.portfolio.primary_web_endpoint
    resource_group  = azurerm_resource_group.main.name
  }
  description = "Summary of deployed resources"
}
