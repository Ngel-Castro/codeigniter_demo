module "web_server" {
  source = "github.com/Ngel-Castro/proxmox_single_vm_module?ref=stable"

  # Pass in required variables
    proxmox_host      = var.proxmox_host
    proxmox_token_id  = var.proxmox_token_id
    proxmox_token_secret = var.proxmox_token_secret
    target_node       = var.target_node
    storage           = var.storage
    full_clone        = var.full_clone
    template_name     = var.template_name
    network_bridge    = var.network_bridge
    memory            = var.memory
    name              = "${var.name}-${var.environment}"
}