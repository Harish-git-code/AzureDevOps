output "public_ip" {
  value       = var.public_ssh ? azurerm_public_ip.pip[0].ip_address : ""
  description = "Public IP of the VM (if public_ssh=true)"
}

output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
}

output "ssh_connection" {
  value = var.public_ssh ? "ssh ${var.admin_username}@${azurerm_public_ip.pip[0].ip_address}" : "No public IP configured"
}
