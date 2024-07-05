environment       = "dev"
containers = [
    { 
        name            = "php-demo", 
        target_node     = "proxmox", 
        storage         = "Kingstone-data",
        storage_size    = "32G",
        full_clone      = true
        template_name   = "samsung-ssd:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
        network_bridge  = "vmbr0"
        memory          = 8192
        cores           = 4
        tags            = "tofu"
        unprivileged    = true
        ip              = "192.168.0.156/24"
        vmid            = 500
        gw              = "192.168.0.1"
    }
]
default_password  = "BasicLXCContainer"
public_key_encryption = "ssh-ed25519"
public_key = "AAAAC3NzaC1lZDI1NTE5AAAAIKOPgZn0hyLV+UGoAZkIUlUYeyIqbSOPYSU+wpqoIZ7h"
dns = "192.168.0.73"