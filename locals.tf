locals {
  lxc_profiles = {
    small = {
      cores  = 1
      memory = 512
      disk   = "5G"
    }
    medium = {
      cores  = 2
      memory = 2048
      disk   = "10G"
    }
    large = {
      cores  = 4
      memory = 4096
      disk   = "20G"
    }
  }
}