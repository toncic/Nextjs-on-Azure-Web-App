# Infrastructure resources

The Azure infrastructure for the platform is managed via code with Terraform.
This directory will contain the Terraform files & pipelines that are used to manage the infrastructure.

The naming convention for all Azure resources should follow this naming pattern: `applicationName–resourceType-environment-serviceName`.

## Terraform

We set the required version to 1.3.7 and higher.
There is a separate terraform configuration for each environment in their own directory.

### State management

The Terraform state is stored remotely in an Azure storage account (each environment separately).
If the storage account (and thus the state) doesn't yet exist, the infra pipeline will create a new storage account for storing the state. The storage account is created in Standard_ZRS mode. It means that is zone redundant, in case of zone failure.

### Running Terraform locally (for development purposes)

#### Using local copy of the state

You may want to run `terraform plan` locally to see how the local changes you have done to infra would affect the resources in Azure before committing and pushing your changes to Git remote.
To do this, follow the steps below:

1. Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) if not installed yet.

2. Login and set account to correct subscription

   ```
   az login
   az account set --subscription "SUBSCRIPTION NAME"
   ```

3. Go to the environment's directory (eg. `terraform/envs/dev`)

4. Download environment's current up-to-date Terraform state from Azure storage account to your local folder

   (_Why not use azurerm backend locally? Because we do not want to obtain file locks on the actual state files in the azure storage for local development purposes as this would make any active DevOps pipeline builds fail. And we want to avoid any accidental local changes to the remote state files_)

   ```
   az storage blob download  -f <env>.local.terraform.tfstate -c tf-<env>-state -n <env>.terraform.tfstate --account-name demonextjswebapp<env>tfstate
   ```

5. Create file `main_override.tf` file with the following contents to use local backend instead of the azurerm backend configured in `main.tf`

   ```
   terraform {
       backend "local" {
           path = "<env>.local.terraform.tfstate "
       }
   }
   ```

   where the path should be to the state file you downloaded.

6. Init terraform using the downloaded state and local backend

   ```
   terraform init
   ```

7. Run terraform plan to see planned changes

   ```
   terraform plan -var-file="<env>.tfvars"
   ```

8. If you are happy with the changes, you should commit and push your changes, create new pull request, review the `terraform plan` changes in the pipeline once again, and then let the DevOps pipeline apply the actual changes to Azure.

## Pipelines

The infrastructure is deployed with the infra pipeline (see [infra-pipeline.yml](pipelines/infra-pipeline.yml)).

At the beginning of every infra deployment pipeline run, the terraform initialization job is run first (see [terraform-init-steps.yml](pipelines/terraform-init-steps.yml)). The job checks if the storage account for the terraform state exists, if it doesn't then the job creates it. The settings are different for production due to security policies.

In the next step [terraform-install-steps.yml](pipelines/terraform-install-steps.yml) it installs Terraform in the required version.
When the backend exists and Terraform is installed, it validates the configuration and makes a plan which is stored as an artifact.
Those steps are repeated for all environments.

In the final step, the plan is deployed (with `terraform apply`) from the file to the proper environment.

### Azure connection

All deployments to Azure are done through a Service Connection (specific per subscription).

### Azure resource group

All resource groups are created (specific per environment) and managed by IT. We have separate resource groups for each environment.
