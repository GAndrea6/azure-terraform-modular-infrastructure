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
    ├── provider.tf                # azurerm provider and remote backend
    ├── variable.tf                # Root input variables
    ├── output.tf                  # Root outputs
    ├── cloud-init.yaml            # Installs and starts nginx on first boot
    ├── terraform.tfvars.example   # Example values (copy to terraform.tfvars)
    └── modules/
        └── network/               # Reusable module: VNet, subnet, NSG, association
```

## Prerequisites

- Terraform >= 1.3.0
- Azure CLI, logged in with `az login`
- An Azure subscription
- A storage account for the remote state (see below)

## Remote state setup (one time)

Storage account names are globally unique: pick your own and update `storage_account_name` in `terraform/provider.tf`.

```bash
az group create --name rg-tfstate-backend --location westeurope
az storage account create --name <unique-name> --resource-group rg-tfstate-backend --location westeurope --sku Standard_LRS
az storage container create --name tfstate --account-name <unique-name>
```

## Usage

```bash
git clone https://github.com/GAndrea6/azure-terraform-modular-infrastructure.git
cd azure-terraform-modular-infrastructure/terraform

cp terraform.tfvars.example terraform.tfvars   # then edit with your own values

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Once deployed, open the VM's public IP in a browser (find it with `terraform output` or in the Azure portal) to see the nginx welcome page.

To remove everything and stop costs:

```bash
terraform destroy
```

## Variables

| Variable | Description | Default |
|---|---|---|
| `resource_group_name` | Main resource group | `rg-lab-nginx` |
| `location` | Azure region | `westeurope` |
| `vm_size` | VM size | `Standard_B2s` |
| `admin_username` | VM admin user | `azureuser` |
| `admin_password` | VM admin password (sensitive) | none, required |
| `allowed_ssh_cidr` | Your public IP in CIDR form, e.g. `203.0.113.10/32` | none, required |

## Security notes

- `terraform.tfvars` and state files are excluded via `.gitignore`; only `terraform.tfvars.example` is committed.
- `admin_password` is marked `sensitive`.
- SSH is restricted to a single address instead of being open to the internet.
- State is stored remotely in Azure Blob Storage.

## Costs

The `Standard_B2s` VM and the Standard public IP are billed while they exist. Run `terraform destroy` when you are done testing.

## What I learned

- Reusable modules: passing inputs in and exposing outputs (subnet ID) to the root module.
- Reading `terraform validate` errors: it caught a VM referencing a network interface that was never declared, and a module deploying into a resource group that did not exist. Both fixed.
- Keeping secrets out of Git: `.gitignore`, example variables file, sensitive variables.

## Next improvements

- Replace password login with SSH key authentication.
- Add a GitHub Actions pipeline running `fmt`, `validate` and `plan` on every pull request.
- Add resource tags and an architecture diagram.
