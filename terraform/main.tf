terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Uncomment and configure to use remote state with Azure Storage
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "tfstatefiles01"
    container_name       = "tfstate"
    key                  = "portfolio.tfstate"
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = true
      skip_shutdown_and_force_delete = false
    }
  }
}

locals {
  project_name = "portfolio"
  environment  = "prod"
  location     = "East US"

  tags = {
    Environment = local.environment
    Project     = local.project_name
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project_name}-${local.environment}"
  location = local.location
  tags     = local.tags
}
