terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-backend"
    storage_account_name = "sttfstategara123"
    container_name       = "tfstate"
    key                  = "lab.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}