module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  location     = var.location
  environment  = var.environment
}

module "bastion" {
  source              = "./modules/bastion"
  project_name        = var.project_name
  location            = var.location
  environment         = var.environment
  resource_group_name = module.network.resource_group_name

  bastion_subnet_id = module.network.bastion_subnet_id
}

module "app_vms" {
  source       = "./modules/app_vms"
  project_name = var.project_name
  location     = var.location
  environment  = var.environment

  resource_group_name = module.network.resource_group_name
  app_subnet_id       = module.network.subnets["app"]
  ssh_public_key_path = var.ssh_public_key_path
}

module "application_gateway" {
  source              = "./modules/application_gateway"
  project_name        = var.project_name
  location            = var.location
  environment         = var.environment

  resource_group_name = module.network.resource_group_name
  public_subnet_id    = module.network.subnets["public"]

  backend_ips = module.app_vms.vm_private_ips
}

module "postgres" {
  source              = "./modules/postgres"
  project_name        = var.project_name
  location            = var.location
  environment         = var.environment

  resource_group_name = module.network.resource_group_name
  vnet_id             = module.network.vnet_id
  data_subnet_id      = module.network.subnets["data"]

  admin_username = "pgadmin"
  admin_password = "123"
}

module "monitoring" {
  source              = "./modules/monitoring"
  project_name        = var.project_name
  location            = var.location
  environment         = var.environment

  resource_group_name     = module.network.resource_group_name
  application_gateway_id  = module.application_gateway.agw_id
  vm_ids                  = module.app_vms.vm_ids
  postgres_id             = module.postgres.postgres_id
}


