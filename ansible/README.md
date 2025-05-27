# AutoExpress Infrastructure with Ansible

This directory contains Ansible playbooks and roles for deploying the AutoExpress application using Docker.

## Directory Structure

```
ansible/
├── group_vars/           # Group variables
├── roles/                # Ansible roles
│   ├── common/           # Common setup for all servers
│   ├── backend/          # Backend server setup
│   ├── frontend/         # Frontend server setup
│   └── mongodb/          # MongoDB setup
├── inventory.ini         # Generated inventory file
├── inventory.tpl         # Inventory template
└── site.yml              # Main playbook
```

## Prerequisites

1. Terraform (v1.0+)
2. Ansible (v2.10+)
3. Python 3.8+
4. DigitalOcean account with API token
5. SSH key added to DigitalOcean

## Deployment

The deployment is handled automatically by Terraform. When you run `terraform apply`, it will:

1. Create the infrastructure on DigitalOcean
2. Generate an Ansible inventory file
3. Run the Ansible playbook to provision and deploy the application

### Manual Deployment (if needed)

If you need to run the Ansible playbook manually:

```bash
# Install Ansible collections
ansible-galaxy collection install -r requirements.yml

# Run the playbook
ansible-playbook -i inventory.ini site.yml
```

## Roles

### Common
- Installs Docker and Docker Compose
- Configures system requirements

### MongoDB
- Sets up MongoDB in a Docker container
- Configures authentication and volumes

### Backend
- Deploys the Node.js backend
- Builds the Docker image
- Configures environment variables
- Sets up the backend service

### Frontend
- Builds the React frontend
- Configures Nginx as a reverse proxy
- Sets up the frontend service

## Environment Variables

Frontend environment variables are configured in `templates/frontend/.env.j2`.

## Troubleshooting

- If the deployment fails, check the logs with `journalctl -u docker` on the target servers
- For Ansible issues, run with `-v` for verbose output
- Ensure your SSH key is added to the SSH agent: `ssh-add ~/.ssh/id_rsa`
