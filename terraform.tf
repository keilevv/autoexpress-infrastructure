terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~>2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "digitalocean_ssh_key" "deployer" {
  name       = "Terraform SSH Key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}


resource "digitalocean_droplet" "mern_server" {
  name   = "mern-droplet"
  region = "nyc3" 
  size   = "s-1vcpu-2gb" 
  image  = "ubuntu-22-04-x64"

ssh_keys = [digitalocean_ssh_key.deployer.id, digitalocean_ssh_key.my_key.id]

 user_data = <<-EOF
            #!/bin/bash
            systemctl enable ssh --now
            systemctl restart ssh
            while lsof /var/lib/dpkg/lock; do sleep 5; done
            apt update && apt upgrade -y
            apt install -y docker.io docker-compose openssh-server

            EOF
}

resource "local_file" "ansible_inventory" {
  content  = <<-EOT
  [droplets]
  my_droplet ansible_host=${digitalocean_droplet.mern_server.ipv4_address} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
  EOT
  filename = "${path.module}/ansible/inventory.ini"

  depends_on = [digitalocean_droplet.mern_server] # Ensure droplet exists before generating inventory
}

resource "null_resource" "ansible_provision" {
  depends_on = [local_file.ansible_inventory] # Ensure inventory is generated before running Ansible

  provisioner "local-exec" {
    command = "cd ansible && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml"
  }
}

output "server_ip" {
  value = digitalocean_droplet.mern_server.ipv4_address
}


resource "digitalocean_ssh_key" "my_key" {
  name       = "autoexpress-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_firewall" "mern_firewall" {
  name = "mern-firewall"

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "27017"
    source_addresses = ["0.0.0.0/0"] # Change this to your IP if MongoDB should not be public
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "all"
    destination_addresses = ["0.0.0.0/0"]
  }

  droplet_ids = [digitalocean_droplet.mern_server.id]
}
