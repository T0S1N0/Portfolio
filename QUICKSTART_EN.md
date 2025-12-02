# Quick Reference - Azure Portfolio

## Portfolio URL

```
https://stportfolio21ecb97f.z13.web.core.windows.net/
```

## Quick Start - First Deployment

```bash
# 1. Clone repository
git clone https://github.com/T0S1N0/Portfolio.git
cd Portfolio

# 2. Authenticate with Azure
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# 3. Create Service Principal (if needed)
az ad sp create-for-rbac --name "github-portfolio" \
  --role "Contributor" \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# 4. Set Azure Environment Variables
export ARM_SUBSCRIPTION_ID="79a2d831-3f82-430f-b4ce-28d5249bdd2d"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="6abef165-c90a-45d7-8a74-25f5ced35d77"

# 5. Deploy Infrastructure
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# 6. Get Your Portfolio URLs
terraform output
```

## Essential Terraform Commands

```bash
terraform init              # Initialize Terraform
terraform validate          # Check syntax
terraform fmt -recursive    # Format code
terraform plan -out=tfplan  # Preview changes
terraform apply tfplan      # Apply changes
terraform output            # Show results
terraform destroy           # Remove all
```

## Azure CLI Commands

```bash
az login                    # Authenticate
az account show             # Show current account
az account set --subscription "ID"
az ad sp create-for-rbac --name "app-name" --role "Contributor"
```

## Customization

Edit `index.html`:

- Update your name, title, skills, projects
- Replace social links (GitHub, LinkedIn)
- Update `miquel-martin-cv.pdf` with your resume

Push changes → GitHub Actions automatically deploys

## Troubleshooting

**Portfolio not loading?**

- Verify Storage Account exists in Azure Portal
- Check Static Website is enabled
- Verify index.html exists in $web container

**Terraform errors?**

```bash
terraform validate
terraform state list
terraform show azurerm_storage_account.portfolio
```

**GitHub Actions failed?**

- Check Actions tab in GitHub
- Review deployment logs
- Verify Azure secrets configured

## File Structure

```
terraform/
├── main.tf          # Resource Group
├── storage.tf       # Storage Account
├── cdn.tf           # CDN (disabled)
├── outputs.tf       # Outputs
└── variables.tf     # Variables

.github/workflows/
├── deploy.yml       # CI/CD Pipeline
└── lint.yml         # Validation

index.html          # Your portfolio
miquel-martin-cv.pdf # Your resume
```

---

**Status**: Production Ready
**Last Updated**: December 2, 2025
