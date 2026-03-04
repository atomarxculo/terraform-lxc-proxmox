variable "proxmox_api_url" {
  type = string
}

variable "proxmox_token_id" {
  type = string
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_node" {
  type = string
}

variable "lxc_template" {
  type    = string
  default = "ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "lxc_storage" {
  type    = string
  default = "local"
}

variable "lxc_password" {
  type      = string
  sensitive = true
}

variable "lxc_count" {
  type = number

  validation {
    condition     = var.lxc_count > 0
    error_message = "lxc_count debe ser mayor que 0."
  }
}

variable "lxc_names" {
  type        = string
  description = "Lista de nombres separada por comas (generada por Jenkins)"
}

variable "lxc_ips" {
  type        = string
  description = "Lista de IPs separadas por comas (validada por Jenkins)"
}

variable "lxc_tags" {
  type        = string
  default     = ""
  description = "Lista de tags separada por comas"
}

variable "lxc_size" {
  type    = string
  default = "small"

  validation {
    condition     = contains(["small", "medium", "large"], var.lxc_size)
    error_message = "lxc_size debe ser: small, medium o large."
  }
}
