output "vm-ip" {
    value = module.web_server.vm_ip
    description = "The IP address of the VM"
}
output "vm-id" {
    value = module.web_server.vm_id
    description = "Virtual Machine ID"
}