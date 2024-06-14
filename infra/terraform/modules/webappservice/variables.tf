variable "service_location" {
  type        = string
  description = "The region where the resources are deployed"

  validation {
    condition     = contains(["West Europe", "North Europe"], var.service_location)
    error_message = "The service_location must be either 'West Europe' (preferred) or 'North Europe'."
  }
}

variable "service_env" {
  type        = string
  description = "The name of the deployment environment for the service"
}

variable "service_rg_name" {
  type        = string
  description = "The name of the Azure Resource Group to use"
}

variable "service_plan_id" {
  type        = string
  description = "The id of the Azure App Service Plan to use"

}

variable "service_name" {
  type        = string
  description = "The name of Azure Web App Service"

  validation {
    condition     = contains(["global"], var.service_name)
    error_message = "The app name are related to project"
  }
}

variable "kv_id" {
  type        = string
  description = "The id of Azure Key Vault Service"
}

variable "service_app_config" {
  type        = map(any)
  description = "Configuration for Azure Web App Service"
}

