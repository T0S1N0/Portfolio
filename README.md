# Portfolio on Azure

Personal portfolio deployed on Microsoft Azure using Infrastructure as Code with Terraform and automated CI/CD with GitHub Actions.

## 🏗️ Architecture

- **Azure Storage Account**: Static website hosting (index.html, CV, etc.)
- **Azure CDN**: Global content distribution with caching
- **GitHub Actions**: CI/CD pipeline for automated deployment
- **Terraform**: Infrastructure as Code management

## 📋 Technologies

- **Cloud**: Microsoft Azure
- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **Frontend**: HTML5 + CSS3
- **Monitoring**: Azure Monitor (optional)

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
│       └── deploy.yml           # CI/CD Pipeline
├── terraform/
│   ├── main.tf                  # Main configuration
│   ├── storage.tf               # Storage Account
│   ├── cdn.tf                   # CDN and endpoints
│   ├── dns.tf                   # DNS (commented)
│   ├── variables.tf             # Terraform variables
│   ├── outputs.tf               # Terraform outputs
│   └── terraform.tfvars         # Default values
├── index.html                   # Website
├── cv.pdf                       # Resume (optional)
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

1. Validates Terraform configuration
2. Plans the changes
3. Applies the infrastructure
4. Uploads website files
5. Invalidates CDN cache

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

To use a custom domain:

1. **Option A: Azure DNS**

   - Uncomment the `dns.tf` section
   - Configure your domain
   - Update nameservers at your registrar

2. **Option B: External Registrar**
   - Create a CNAME record pointing to your CDN endpoint
   - Example: `www.yourdomain.com CNAME → cdn-portfolio-prod.azureedge.net`

## 📊 Monitoring

Azure provides automatic monitoring through:

- **Azure Portal**: Monitor Storage and CDN usage
- **Application Insights**: Analyze traffic (optional)
- **Azure Monitor**: Custom alerts (optional)

## 💰 Costs

The Azure stack used is very economical:

- **Storage Account**: ~$0.60/month (for 1GB)
- **CDN**: ~$0.17/GB transferred (first 10TB)
- **Estimated total**: $5-50/month depending on traffic

The first 1TB of monthly egress has reduced pricing.

## 🔐 Security

- ✅ HTTPS enforced (CDN provides SSL/TLS certificates)
- ✅ Storage Account with minimum TLS 1.2
- ✅ Public access only for specific files
- ✅ Service Principal with limited permissions

## 🐛 Troubleshooting

### Error: "Resource group already exists"

```bash
# Change the name in main.tf or use terraform import
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/...
```

### CDN takes time to update

The CDN may take up to 30 minutes to propagate changes. Use the direct Storage URL in the meantime:

- Storage URL: `https://st[account].blob.core.windows.net/$web/index.html`

### Authentication errors in GitHub Actions

Verify that secrets are configured correctly:

```bash
# Test locally
az login --service-principal -u $AZURE_CLIENT_ID \
  -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
```

## 📚 Useful Resources

- [Azure Storage Static Website Documentation](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure CDN Pricing](https://azure.microsoft.com/en-us/pricing/details/cdn/)

## 📄 License

This project is available under the MIT license.

## 👤 Author

**Miquel Martin Leiva**

- GitHub: [@T0S1N0](https://github.com/T0S1N0)
- LinkedIn: [Miquel Martin Leiva](https://www.linkedin.com/in/miquel-martin-leiva/)

---

**Last updated**: December 1, 2025
