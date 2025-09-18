#!/usr/bin/env bash
set -euo pipefail

if [ ! -f terraform.tfvars ]; then
  echo "Please create terraform.tfvars (you can copy terraform.tfvars.example) and add your ssh_public_key and repo_url"
  exit 1
fi

terraform init -input=false
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan
