terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true
}

locals {
  profile    = local.lxc_profiles[var.lxc_size]
  lxc_names  = split(",", var.lxc_names)
  lxc_ips    = split(",", var.lxc_ips)
  lxc_tags   = replace(var.lxc_tags, ",", ";")
}

resource "proxmox_lxc" "lxc" {
  count       = var.lxc_count
  hostname    = local.lxc_names[count.index]
  target_node = var.proxmox_node

  ostemplate   = "local:vztmpl/${var.lxc_template}"
  cores        = local.profile.cores
  cpuunits     = 100
  memory       = local.profile.memory
  password     = var.lxc_password
  unprivileged = true
  onboot       = true
  start        = true
  tags         = local.lxc_tags

  ssh_public_keys = <<-EOT
    ${file("~/.ssh/id_rsa.pub")}
  EOT

  rootfs {
    storage = var.lxc_storage
    size    = local.profile.disk
  }

  mountpoint {
    mp    = "/var/lib/docker"
    size    = local.profile.disk  
    slot    = 0 
    key     = "0"  
    storage = var.lxc_storage
  }

  mountpoint {
    mp    = "/var/datos"
    size    = local.profile.disk 
    slot    = 1
    key     = "1"
    storage = var.lxc_storage
  }

  features {
    nesting = true
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${local.lxc_ips[count.index]}/24"
    type   = "veth"
  }
}
