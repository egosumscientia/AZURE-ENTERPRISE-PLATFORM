# Proceso completo: Terraform + Ansible (Azure Enterprise Demo)

## 1. Estructura del proyecto
```
AZURE-ENTERPRISE-PLATFORM/
  terraform/
  ansible/
    ansible.cfg
    inventory/
      azure.ini
    playbooks/
      bootstrap.yml
      app_install.yml
      hardening.yml
    roles/
      bootstrap/
      app_install/
      hardening/
```

---

## 2. Fase Terraform
### 2.1 Ingresar al directorio Terraform
```
cd AZURE-ENTERPRISE-PLATFORM/terraform
```

### 2.2 Inicializar
```
terraform init
```

### 2.3 Validar
```
terraform validate
```

### 2.4 Plan
```
terraform plan
```

### 2.5 Aplicar
```
terraform apply -auto-approve
```

---

## 3. Obtener IPs reales (salida JSON)
```
terraform output -json
```

Ejemplo de salida:
```
{
  "app_vm_private_ips": {
    "value": [
      "10.10.20.4",
      "10.10.20.5"
    ]
  },
  "bastion_private_ip": {
    "value": "10.10.1.4"
  }
}
```

---

## 4. Construir azure.ini con valores reales
Ingresar al folder Ansible:
```
cd ../ansible
```

Editar `inventory/azure.ini`:
```
[app_vms]
appvm01 ansible_host=<IP_1_REAL>
appvm02 ansible_host=<IP_2_REAL>

[bastion]
bastion01 ansible_host=<IP_BASTION_REAL>

[all:vars]
ansible_user=azureuser
ansible_python_interpreter=/usr/bin/python3
```

---

## 5. Verificar conectividad SSH (opcional)
```
ssh azureuser@<IP_BASTION_REAL>
```

---

## 6. Fase Ansible
### Confirmar ubicación
```
cd AZURE-ENTERPRISE-PLATFORM/ansible
```

---

## 7. Ejecución de playbooks
### 7.1 Bootstrap
```
ansible-playbook playbooks/bootstrap.yml
```

### 7.2 App Install
```
ansible-playbook playbooks/app_install.yml
```

### 7.3 Hardening
```
ansible-playbook playbooks/hardening.yml
```

---

## 8. Resultado final
### Terraform
- Red corporativa
- Subredes
- NSGs
- Bastion
- VMs privadas
- Application Gateway Standard_v2
- PostgreSQL Flexible Server
- Private Endpoint
- Log Analytics Workspace
- Diagnostics

### Ansible
- Bootstrap básico
- Instalación de paquetes de aplicación
- Hardening elemental
- Configuración reproducible y modular

---

Fin del documento técnico para copiar y pegar. 