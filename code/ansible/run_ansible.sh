#!/bin/bash
set -e

PROJECT_NAME=${1:-"cowing"}
ENV=${2:-"prod"}
PLAYBOOK=${3:-"main.yml"}

echo "Running Ansible playbook: $PLAYBOOK"
echo "Project: $PROJECT_NAME-$ENV"
echo "==========================================="

# Check if required files exist
if [ ! -f "ansible.cfg" ]; then
    echo "ERROR: ansible.cfg not found!"
    exit 1
fi

if [ ! -f "inventory/bastion_hosts.yml" ]; then
    echo "ERROR: inventory/bastion_hosts.yml not found!"
    exit 1
fi

if [ ! -f "playbooks/$PLAYBOOK" ]; then
    echo "ERROR: playbooks/$PLAYBOOK not found!"
    exit 1
fi

# Check if bastion key exists
if [ ! -f "../terraform/utils/bastion_key" ]; then
    echo "ERROR: Bastion SSH key not found at ../terraform/utils/bastion_key"
    echo "Please run the bastion connection script first to generate the key"
    exit 1
fi

# Set proper permissions for SSH key
chmod 600 ../terraform/utils/bastion_key

# Run ansible playbook
echo "Executing: ansible-playbook -i inventory/bastion_hosts.yml playbooks/$PLAYBOOK"
echo "==========================================="

ansible-playbook -i inventory/bastion_hosts.yml playbooks/$PLAYBOOK \
  -e "project_name=$PROJECT_NAME" \
  -e "environment=$ENV" \
  -v

echo "==========================================="
echo "Ansible playbook execution completed!"
