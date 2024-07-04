all:
  children:
%{ for idx, vm in jsondecode(vms_inventory) ~}
    ${vm.name}:
        children:
            manager:
                hosts:
                    ${vm.name}1:
                        ansible_host: "${vm.ip}"
                        ansible_user: "root"
                        platform_environment: '{{ platform_environment }}'
%{ endfor ~}