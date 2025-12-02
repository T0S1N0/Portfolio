# Portfolio on Azure

Personal portfolio deployed on Microsoft Azure using Infrastructure as Code with Terraform and automated CI/CD with GitHub Actions.

## 🏗️ Architecture

- **Azure Storage Account**: Static website hosting (index.html, CV, etc.) with GRS replication
- **GitHub Actions**: CI/CD pipeline for automated deployment and validation
- **Terraform**: Infrastructure as Code management
- **Website**: HTML5 + CSS3 responsive design hosted on Azure Storage

## 📋 Technologies

- **Cloud**: Microsoft Azure
- **IaC**: Terraform v1.6.5+
- **CI/CD**: GitHub Actions with artifact management
- **Frontend**: HTML5 + CSS3
- **Storage**: Azure Storage Account (StorageV2, GRS)

## 🚀 Prerequisites

### Azure Credentials

You need a Service Principal in Azure. Create one with:

```bash
# Replace with your values
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Create Service Principal
az ad sp create-for-rbac --name "github-portfolio-deployment" \
  --role "Contributor" \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

This will provide:

- `appId` → AZURE_CLIENT_ID
- `password` → AZURE_CLIENT_SECRET
- `tenant` → AZURE_TENANT_ID

### Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add the following secrets:

- `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID
- `AZURE_CLIENT_ID`: appId from the Service Principal
- `AZURE_CLIENT_SECRET`: password from the Service Principal
- `AZURE_TENANT_ID`: tenant from the Service Principal
- `AZURE_STORAGE_ACCOUNT`: (Optional) Storage account name
- `AZURE_STORAGE_KEY`: (Optional) Storage account access key

## 📁 Project Structure

```
Portfolio/
├── .github/
│   └── workflows/
│       ├── deploy.yml           # Azure deployment CI/CD
│       └── lint.yml             # Terraform linting & validation
├── terraform/
│   ├── main.tf                  # Resource group configuration
│   ├── storage.tf               # Storage Account & Static Website
│   ├── cdn.tf                   # CDN config (currently disabled)
│   ├── dns.tf                   # DNS configuration (optional)
│   ├── variables.tf             # Terraform variables
│   ├── outputs.tf               # Terraform outputs
│   └── terraform.tfvars         # Environment configuration
├── index.html                   # Portfolio website
├── miquel-martin-cv.pdf         # Resume/CV
└── README.md                    # This file
```

## 🛠️ Deploy Locally

### 1. Clone the repository

```bash
git clone https://github.com/your-username/Portfolio.git
cd Portfolio
```

### 2. Configure Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Set Azure environment variables
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
```

### 3. Plan the deployment

```bash
terraform plan
```

### 4. Apply the configuration

```bash
terraform apply
```

Terraform will display outputs with your portfolio URL.

## 📤 Automated Deployment

When you push to the `main` branch, GitHub Actions automatically:

1. Validates Terraform configuration (`terraform fmt`, `terraform validate`)
2. Plans the infrastructure changes (`terraform plan`)
3. Applies the infrastructure (`terraform apply`)
4. Uploads website files to Storage Account
5. Validates deployment health

The portfolio is then accessible at:
```
https://st[account-hash].z13.web.core.windows.net/
```

## 📝 Customize Your Portfolio

### Edit content

- **index.html**: Modify HTML/CSS content
- **cv.pdf**: Replace with your resume
- **Contact data**: Update navigation links

### Update personal information

In `index.html`, find and update:

- Name
- Description
- LinkedIn, GitHub links
- Skills information
- Projects

### Add static files

Any file added to the root directory will be automatically uploaded by Terraform.

## 🌐 Custom Domain

To use a custom domain, you have two options:

1. **Azure Storage Custom Domain** (Requires SSL/TLS support)
   - Configure in Azure Portal: Storage Account → Static website → Custom domain
   - Requires separate SSL certificate

2. **Azure Front Door** (Recommended for production)
   - Provides global distribution, SSL/TLS termination, and WAF
   - Can be enabled by uncommenting `azure-front-door` configuration in `cdn.tf`
   - Provides automatic certificate management

For now, use the Storage Account URL or configure through Azure Portal.

## 📊 Monitoring

Azure provides automatic monitoring through:

- **Azure Portal**: Monitor Storage and CDN usage
- **Application Insights**: Analyze traffic (optional)
- **Azure Monitor**: Custom alerts (optional)

## 💰 Costs

The Azure infrastructure is extremely economical:

- **Storage Account**: ~$0.60/month (GRS replication)
- **Static Website Hosting**: Included with Storage Account
- **Estimated total**: $5-15/month

There are no CDN costs. For very low traffic, costs can be under $5/month.

**Cost Reduction Tips:**
- Use LRS (locally redundant storage) instead of GRS for lower costs
- Monitor Storage Account usage in Azure Portal

## 🔐 Security

- ✅ HTTPS/SSL enforced by Storage Account
- ✅ Minimum TLS 1.2 required
- ✅ Public access limited to `$web` container only
- ✅ Service Principal with Contributor role (limited scope)
- ✅ GitHub Secrets for sensitive credentials
- ✅ Infrastructure as Code for audit trail

## 🐛 Troubleshooting

### Portfolio not loading

1. Check Storage Account Static Website is enabled in Azure Portal
2. Verify `index.html` exists in `$web` container
3. Confirm Storage Account is public (not blocked)

Example direct URLs to test:
```
# Index page
https://st[account].z13.web.core.windows.net/index.html

# Direct blob access
https://st[account].blob.core.windows.net/$web/index.html
```

### Terraform errors

```bash
# Check state
terraform state list

# Validate configuration
terraform validate

# Format check
terraform fmt -recursive
```

### GitHub Actions failures

1. Check GitHub Actions logs for specific errors
2. Verify Azure Service Principal credentials are correct
3. Ensure secrets are properly configured in GitHub repository settings
4. Confirm Service Principal has Contributor role on subscription

## 📚 Useful Resources

- [Azure Storage Static Website Documentation](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure Storage Pricing](https://azure.microsoft.com/en-us/pricing/details/storage/blobs/)
- [Azure Front Door (CDN Alternative)](https://docs.microsoft.com/en-us/azure/frontdoor/)

## 📄 License

This project is available under the MIT license.

## 👤 Author

**Miquel Martin Leiva**

- GitHub: [@T0S1N0](https://github.com/T0S1N0)
- LinkedIn: [Miquel Martin Leiva](https://www.linkedin.com/in/miquel-martin-leiva/)

---

**Last updated**: December 2, 2025
