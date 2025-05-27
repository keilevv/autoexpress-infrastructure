output "frontend_public_ip" {
  description = "Public IP address of the frontend server"
  value       = digitalocean_droplet.frontend.ipv4_address
}

output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = digitalocean_loadbalancer.public.ip
}

output "backend_servers_public_ips" {
  description = "Public IP addresses of the backend servers"
  value       = digitalocean_droplet.backend[*].ipv4_address
}

output "mongodb_private_ip" {
  description = "Private IP address of the MongoDB server"
  value       = digitalocean_droplet.mongodb.ipv4_address_private
}

output "frontend_url" {
  description = "URL to access the frontend"
  value       = "http://${digitalocean_droplet.frontend.ipv4_address}"
}

output "load_balancer_url" {
  description = "URL to access the load balancer"
  value       = "http://${digitalocean_loadbalancer.public.ip}"
}
