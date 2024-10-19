terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

variable "USER" {
  description = "The user Terraform connects to Proxmox with"
}

variable "PM_API_TOKEN_ID" {
  description = "The Proxmox Token ID"
}

variable "PM_API_TOKEN_SECRET" {
  description = "The Proxmox Token Secret"
}

variable "PROXMOX_IP" {
  description = "The Proxmox host API URL"
}

variable "PROXMOX_TARGET" {
  description = "The Proxmox target"
}

provider "proxmox" {
 pm_api_url   = "https://${var.PROXMOX_IP}:8006/api2/json"
 pm_api_token_id = "${var.USER}!${var.PM_API_TOKEN_ID}"
 pm_api_token_secret = var.PM_API_TOKEN_SECRET
 pm_tls_insecure = true
}

# All hosts
resource "proxmox_vm_qemu" "docker-host" {
  name       = "docker-host-test"
  # !!! The target node is in this case is called 'vmhost' this should be changed when running it on your infra !!!
  target_node = var.PROXMOX_TARGET
  clone      = "debian-xfs-dual-nic"
  cores      = 2
  memory     = 2048
  
  # Set the network, VLAN Tag 50 signifies an isolated VLAN on the main interface
  network {
    model = "virtio"
    bridge = "vmbr1"
    tag = 50
  }

  # Storage configuration
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = "scsi0"
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size = "40G"
    type = "disk"
    # When using ZFS as your backend - change this value to local-zfs
    storage = "local-lvm"
  }

  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}