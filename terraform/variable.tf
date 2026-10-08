variable "resource_group_name" {
    type = string 
    default = "rg-lab-nginx"
}

variable "location" {
    type = string 
    default = "eastus"
}

variable "vm_size" {
    type = string
    default = "Standard_B2s"
}

variable "admin_username" {
    type = string 
    default = "azureuser"
}

variable "admin_password" {
    type = string 
    sensitive = true 
}