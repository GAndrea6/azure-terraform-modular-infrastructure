# Azure Modular Infrastructure with Terraform

Modular, reproducible Azure infrastructure defined as code with Terraform: a virtual network built from a reusable module, a Linux VM running nginx (installed via cloud-init), and remote state stored in Azure Blob Storage.

**Status:** configuration validated with `terraform validate`; end-to-end deployment test in progress.

## What it deploys

| Resource | Details |
|---|---|
| Resource group | `rg-lab-nginx` (default, configurable) |
| Virtual network | `vnet-prod`, `10.0.0.0/16` (module `network`) |
| Subnet | `snet-web`, `10.0.1.0/24` |
| Network security group | `nsg-web`, associated to the subnet. SSH (22) allowed only from `allowed_ssh_cidr`, HTTP (80) from anywhere |
| Public IP | Static, Standard SKU |
| Network interface | Connects the VM to the subnet and the public IP |
| Linux VM | Ubuntu 22.04 LTS, `Standard_B2s`, nginx installed with cloud-init |
| Remote state | Azure Blob Storage backend (`azurerm`) |

## Structure

```
.
├── README.md
├── .gitignore
└── terraform/
    ├── main.tf                    # Resource group, public IP, network module, NIC, VM
    ├── provider.tf                # azurerm
