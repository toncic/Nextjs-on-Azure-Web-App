# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.82.0"
    }
  }

  required_version = ">= 1.4.5"

  # The configuration for this backend will be filled in by Azure DevOps Pipeline
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}
