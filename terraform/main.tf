module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  location     = var.location
}

module "bastion" {
  source       = "./modules/bastion"
  project_name = var.project_name
  location     = var.location
}

module "app_vms" {
  source       = "./modules/app_vms"
  project_name = var.project_name
  location     = var.location
}

module "application_gateway" {
  source       = "./modules/application_gateway"
  project_name = var.project_name
  location     = var.location
}

module "postgres" {
  source       = "./modules/postgres"
  project_name = var.project_name
  location     = var.location
}

module "monitoring" {
  source       = "./modules/monitoring"
  project_name = var.project_name
  location     = var.location
}
