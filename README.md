
## AZURE MODULAR INFRASTRUCTURE LAB


# OBJECTIVE
Design, deploy, and manage a modular and reproducible cloud 
infrastructure on Microsoft Azure using Terraform (Infrastructure as Code) 
with remote state management stored in Azure Blob Storage.


# ARCHITECTURE
Azure Subscription
│
├── Remote Backend (Azure Blob Storage)
│   └── rg-tfstate-backend / sttfstategara123 / tfstate / lab.terraform.tfstate
│
├── Main Resource Group (rg-lab-nginx / East US)
│   ├── Public IP (Static, Standard SKU)
│   └── Linux Virtual Machine (vm-lab: Ubuntu 22.04 LTS, Standard_B2s)
│
└── Network Module (rg-prod / West Europe)
    └── Virtual Network (vnet-prod: 10.0.0.0/16)
        └── Subnet (snet-web: 10.0.1.0/24)
            └── Network Security Group (nsg-web)
            
# Project Structure:
.
├── main.tf                  # Root resources (RG, Public IP, Network Module, VM)
├── provider.tf              # AzureRM Provider & Remote Backend setup
├── variable.tf              # Root input variables
├── output.tf                # Root outputs (RG Name, Public IP)
├── terraform.tfvars.example # Example local variables
└── modules/
    └── network/             # Reusable network module
        ├── main.tf          # VNet, Subnet, NSG, and NSG-Subnet Association
        ├── variable.tf      # Network module input variables
        └── output.tf        # Network module outputs


# PREREQUISITES
* Terraform CLI (>= 1.3.0)
* Azure CLI
* An active Azure subscription
* An existing Azure Storage Account for the remote backend
  (rg-tfstate-backend / sttfstategara123)


# INSTALLATION
1. Clone the repository:
   git clone https://github.com/GAndrea6/Terraform-Project.git
   cd Terraform-Project

2. Configure local variables:
   cp terraform.tfvars.example terraform.tfvars
   (Define the sensitive admin_password variable inside terraform.tfvars)

3. Authenticate to Azure:
   az login


# TERRAFORM COMMANDS

* Initialize project and remote backend:
  terraform init

* Code formatting and validation:
  terraform fmt -recursive
  terraform validate

* Execution planning:
  terraform plan

* Deployment:
  terraform apply -auto-approve

* Infrastructure destruction:
  terraform destroy -auto-approve


# NETWORKING
The network architecture is defined in the dedicated ./modules/network module:
* Virtual Network (VNet): vnet-prod with IP address space 10.0.0.0/16.
* Subnet: snet-web with IP prefix 10.0.1.0/24.
* Public IP: Static Standard SKU Public IP assigned to the network interface 
  for external connectivity.


# SECURITY

* Network Security Group (NSG): nsg-web associated directly with snet-web 
  for network traffic filtering and control.
* VM Authentication: Administrative credentials securely handled using 
  variables marked as sensitive (admin_password).
* Remote State Security: State file (.tfstate) is secured and stored 
  remotely in Azure Blob Storage.


# TROUBLESHOOTING

* "backend azurerm" state container access error:
  Verify that you are logged in via "az login" with the correct account 
  and that the Resource Group "rg-tfstate-backend" and Storage Account 
  "sttfstategara123" exist on Azure.

* Missing "admin_password" during terraform plan:
  Ensure you have created terraform.tfvars from terraform.tfvars.example 
  and provided a value for admin_password.

* Network interface association or resource dependency issues:
  Run terraform validate to check for undeclared references before running 
  terraform apply.
