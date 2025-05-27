provider "digitalocean" {
  token = var.do_token
}

# Use the default VPC
data "digitalocean_vpc" "default" {
  name = "autoexpress-vpc"
}

# Create Frontend Droplet
resource "digitalocean_droplet" "frontend" {
  image     = "ubuntu-22-04-x64"
  name      = "${var.project_name}-frontend"
  region    = var.region
  size      = var.droplet_size
  vpc_uuid  = data.digitalocean_vpc.default.id
  ssh_keys  = var.ssh_keys
  user_data = file("${path.module}/cloud-init/frontend.yaml")
}

# Create Backend Droplets
resource "digitalocean_droplet" "backend" {
  count    = 2
  image    = "ubuntu-22-04-x64"
  name     = "${var.project_name}-backend-${count.index + 1}"
  region   = var.region
  size     = var.droplet_size
  vpc_uuid = data.digitalocean_vpc.default.id
  ssh_keys = var.ssh_keys
  user_data = templatefile("${path.module}/cloud-init/backend.yaml", {
    mongodb_ip = digitalocean_droplet.mongodb.ipv4_address_private
  })
}

# Create MongoDB Droplet
resource "digitalocean_droplet" "mongodb" {
  image     = "ubuntu-22-04-x64"
  name      = "${var.project_name}-mongodb"
  region    = var.region
  size      = var.droplet_size
  vpc_uuid  = data.digitalocean_vpc.default.id
  ssh_keys  = var.ssh_keys
  user_data = file("${path.module}/cloud-init/mongodb.yaml")
}

# Create Load Balancer
resource "digitalocean_loadbalancer" "public" {
  name   = "${var.project_name}-loadbalancer"
  region = var.region
  vpc_uuid = data.digitalocean_vpc.default.id

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 5000
    target_protocol = "http"
  }

  healthcheck {
    port     = 5000
    protocol = "http"
    path     = "/api/health"
  }

  droplet_ids = digitalocean_droplet.backend.*.id
}

# Outputs
output "frontend_ip" {
  value = digitalocean_droplet.frontend.ipv4_address
}

output "load_balancer_ip" {
  value = digitalocean_loadbalancer.public.ip
}

output "backend_ips" {
  value = digitalocean_droplet.backend[*].ipv4_address
}

output "mongodb_ip" {
  value = digitalocean_droplet.mongodb.ipv4_address_private
}
