variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc3"
}

variable "project_name" {
  description = "Project name for resources"
  type        = string
  default     = "autoexpress"
}

variable "droplet_size" {
  description = "Droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "ssh_keys" {
  description = "List of SSH key fingerprints to add to droplets"
  type        = list(string)
  default     = []
}
