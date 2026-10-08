variable "resource_group_name" {
  type        = string
  description = "Nome del Resource Group esistente"
}

variable "location" {
  type        = string
  description = "Region Azure per la distribuzione"
}

variable "vnet_name" {
  type        = string
  description = "Nome della Virtual Network"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Spazio d'indirizzamento IP per la VNet"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "Nome della Subnet"
}

variable "subnet_address_prefix" {
  type        = list(string)
  description = "Prefisso IP per la Subnet"
  default     = ["10.0.1.0/24"]
}

variable "nsg_name" {
  type        = string
  description = "Nome del Network Security Group"
}

variable "tags" {
  type        = map(string)
  description = "Tag di identificazione per le risorse"
  default     = {}
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to connect via SSH"
}