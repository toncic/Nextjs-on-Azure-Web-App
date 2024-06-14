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
