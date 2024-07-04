output "lxc-ip" {
    value = local.containers_inventory.ip
    description = "LXC(s) inventory"
}