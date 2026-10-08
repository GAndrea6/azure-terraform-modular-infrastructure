resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name 
    location = var.location 
}

resource "azurerm_public_ip" "pip" {
    name = "public-ip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
    sku = "Standard"
}


module "network_prod" {
  source = "./modules/network" # Percorso locale del modulo

  # Passaggio dei parametri al modulo
  resource_group_name   = "rg-prod"
  location              = "westeurope"
  vnet_name             = "vnet-prod"
  vnet_address_space    = ["10.0.0.0/16"]
  subnet_name           = "snet-web"
  subnet_address_prefix = ["10.0.1.0/24"]
  nsg_name              = "nsg-web"
}

resource "azurerm_linux_virtual_machine" "vm" {
    name = "vm-lab"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = var.vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    disable_password_authentication = false

    network_interface_ids = [
        azurerm_network_interface.nic.id,
    ]

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }
}
