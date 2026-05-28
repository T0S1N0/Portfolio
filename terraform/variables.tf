# Variables for Terraform configuration

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = ""
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "East US"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "enable_static_web_app" {
  type        = bool
  description = "Enable Azure Static Web App resources for migration."
  default     = false
}

variable "swa_sku_tier" {
  type        = string
  description = "Azure Static Web App SKU tier."
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.swa_sku_tier)
    error_message = "swa_sku_tier must be Free or Standard."
  }
}

variable "swa_sku_size" {
  type        = string
  description = "Azure Static Web App SKU size."
  default     = "Free"
}
