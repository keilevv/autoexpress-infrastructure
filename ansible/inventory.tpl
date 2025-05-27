[frontend]
frontend ansible_host={{ frontend_private_ip }}

[backend]
backend ansible_host={{ backend_private_ip }}

[db]
db ansible_host={{ mongodb_private_ip }}

[load_balancer]
load_balancer ansible_host={{ load_balancer_ip }}

[all:vars]
ansible_user=root
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file={{ private_key_path }}
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
