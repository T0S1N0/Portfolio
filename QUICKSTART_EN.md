# 📚 Quick Reference - Azure Portfolio

## 🚀 Quick Start - First Deployment

\\\ash
# 1. Clone repository
git clone https://github.com/T0S1N0/Portfolio.git
cd Portfolio

# 2. Configure Azure CLI
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# 3. Create Service Principal
az ad sp create-for-rbac --name "github-portfolio" \
  --role "Contributor" \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# 4. Set Azure Variables
export ARM_SUBSCRIPTION_ID="..."
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
export ARM_TENANT_ID="..."

# 5. Deploy
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# 6. Get Your Portfolio URL
terraform output
\\\

## 📝 Common Changes

### Update Website Name
In \index.html\ around line 320:
\\\html
<h1>Your Name</h1>
<p>Your Description</p>
\\\

### Update Links
In \index.html\ nav:
\\\html
<a href="https://github.com/YOUR_USERNAME">GitHub</a>
<a href="https://linkedin.com/in/your-profile">LinkedIn</a>
\\\

## 🔧 Essential Terraform Commands

\\\ash
terraform init          # Initialize
terraform validate      # Check syntax
terraform plan          # Preview changes
terraform apply         # Deploy
terraform output        # Show results
terraform destroy       # Remove all
\\\

## 🔐 Azure CLI Commands

\\\ash
az login                # Authenticate
az account show         # Show current account
az account set --subscription "ID"
az ad sp create-for-rbac --name "app-name"
\\\

---

**Status**: Production Ready
**Last Updated**: December 1, 2025
