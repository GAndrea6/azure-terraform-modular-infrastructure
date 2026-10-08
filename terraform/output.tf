output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Nome del Resource Group creato"
}

output "public_ip_address" {
  value       = azurerm_public_ip.pip.ip_address
  description = "Indirizzo IP Pubblico assegnato alla VM"
}