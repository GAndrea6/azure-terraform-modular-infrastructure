variable "resource_group_name" {
  type    = string
  default = "rg-lab-nginx"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Your public IP in CIDR form, e.g. 203.0.113.10/32"
}