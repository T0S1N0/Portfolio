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
}
