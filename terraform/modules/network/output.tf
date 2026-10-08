output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID della VNet creata"
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "ID della Subnet creata"
}

output "nsg_id" {
  value       = azurerm_network_security_group.nsg.id
  description = "ID del Network Security Group"
}