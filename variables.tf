variable "prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "3tier"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-3tier-sample"
}

variable "vm_name" {
  description = "VM name"
  type        = string
  default     = "appvm"
}

variable "vm_size" {
  description = "Azure VM size (choose per your needs)"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin user for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key contents"
  type        = string
  sensitive   = false
}

variable "repo_url" {
  description = "Git URL for your app (GitHub or Bitbucket). Use HTTPS clone URL."
  type        = string
  default     = ""
}

variable "repo_branch" {
  description = "Branch to checkout"
  type        = string
  default     = "main"
}

variable "startup_command" {
  description = "Command to start the app after cloning. Will be executed in repo root. If empty, script will try docker-compose up -d or ./startup.sh"
  type        = string
  default     = ""
}

variable "public_ssh" {
  description = "Expose SSH via public IP? (true/false)"
  type        = bool
  default     = true
}
