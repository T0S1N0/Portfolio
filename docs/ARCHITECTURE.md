# Portfolio Architecture on Azure

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      Internet / Users                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────┐
        │   Azure Storage Account Static Website │
        │   https://st[account].z13.web.core...  │
        │   - index.html (Portfolio)             │
        │   - cv.pdf (Resume)                    │
        │   - GRS Replication (Redundancy)       │
        │   - TLS 1.2 Minimum                    │
        └────────────────────┬───────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────┐
        │        Azure Resource Group            │
        │   rg-portfolio-prod (East US)          │
        │   - Managed by Terraform               │
        │   - Infrastructure as Code             │
        └────────────────────────────────────────┘
```

## 🔄 Deployment Flow

```
┌─────────────┐
│   Commit    │
│  to GitHub  │
└──────┬──────┘
       │
       ▼
┌──────────────────────────────┐
│   GitHub Actions Triggered   │
│   (Push to main branch)      │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Validate Terraform Config   │
│  - terraform fmt -check      │
│  - terraform validate        │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Plan Infrastructure Changes │
│  - terraform plan -out=tfplan│
│  - Upload artifacts (v4)     │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Deploy to Azure             │
│  - terraform apply tfplan    │
│  - Create Storage Account    │
│  - Upload files to $web      │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Validate Deployment         │
│  - Test website health       │
│  - Verify accessibility      │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Website Live & Accessible   │
│  - Portfolio updated         │
│  - Users can access          │
└──────────────────────────────┘
```

## 📊 Core Components

### 1. Azure Storage Account
- **Type**: General Purpose v2 (StorageV2)
- **Replication**: GRS (Geo-Redundant Storage)
- **Location**: East US
- **Hosting**: Static Website enabled
- **Container**: `$web` (publicly readable)
- **Files**:
  - `index.html` (Portfolio website)
  - `miquel-martin-cv.pdf` (Resume)
- **Access**: Public for `$web` container only
- **TLS**: Minimum 1.2

### 2. Resource Group
- **Name**: `rg-portfolio-prod`
- **Location**: East US
- **Purpose**: Contains all Azure resources
- **Management**: Terraform managed

### 3. Terraform Configuration
- **Provider**: Azure Resource Manager (azurerm) v3.117.1
- **Backend**: Local state (can migrate to Azure Storage)
- **Files**:
  - `main.tf` - Resource Group
  - `storage.tf` - Storage Account & Static Website
  - `cdn.tf` - CDN configuration (currently disabled)
  - `dns.tf` - DNS (optional)
  - `variables.tf` - Input variables
  - `outputs.tf` - Outputs (URLs, IDs)

### 4. GitHub Actions Workflows

#### deploy.yml
- **Trigger**: Push to main, PR to main, manual dispatch
- **Jobs**:
  1. `terraform-plan` - Validates and plans
  2. `deploy` - Applies to Azure (main push only)
  3. `validate-deployment` - Verifies health
- **Artifacts**: Uses `actions/upload-artifact@v4` (updated from v3)

#### lint.yml
- **Trigger**: PR with terraform changes
- **Jobs**:
  1. `terraform-lint` - Format and validation
  2. `tfsec` - Security scanning

## 🔐 Security

```
┌─────────────────────────────────────────┐
│     GitHub Secrets (Encrypted)          │
│  - AZURE_SUBSCRIPTION_ID                │
│  - AZURE_CLIENT_ID                      │
│  - AZURE_CLIENT_SECRET                  │
│  - AZURE_TENANT_ID                      │
└──────────────┬──────────────────────────┘
               │
               ▼
        ┌──────────────────────┐
        │ Service Principal    │
        │ (Limited Scope)      │
        │ (Contributor Role)   │
        └──────────┬───────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │ Azure Subscription   │
        │ (Create/Update)      │
        └──────────────────────┘
```

### Security Features:
- ✅ Service Principal authentication
- ✅ Limited permissions (Contributor on subscription)
- ✅ HTTPS/TLS 1.2 minimum
- ✅ Public access only to `$web` container
- ✅ Infrastructure as Code for audit trail
- ✅ GitHub Actions logs for deployment history

## 💾 State Management

### Current Setup (Local)
```
terraform/
├── .terraform/
├── terraform.tfstate
└── terraform.tfstate.backup
```

**Note**: Local state is fine for personal projects. For team environments, consider:

### Recommended (Azure Storage Backend)
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateXXXX"
    container_name       = "tfstate"
    key                  = "portfolio.tfstate"
  }
}
```

## 📈 Scalability

```
Low Traffic (0-100 requests/month)
├── Storage: ~$0.60/month
├── No CDN costs
└── Total: <$1/month

Medium Traffic (100-10,000 requests/month)
├── Storage: ~$1-5/month
├── No CDN costs
└── Total: $1-5/month

High Traffic (10,000+ requests/month)
├── Storage: ~$5-10/month
├── Optional CDN: +$5-20/month
└── Total: $5-30/month
```

**Cost Optimization**:
- Currently using GRS (redundancy)
- Can switch to LRS (Locally Redundant) for lower cost
- No egress charges for same-region access
- First 5GB/month free in Azure free tier

## 🌐 CDN Status

### Current: Disabled
- **Reason**: All Azure CDN SKUs (Standard_Akamai, Standard_Verizon, Premium_Verizon, Standard_Microsoft) are deprecated
- **Impact**: None - Storage endpoint provides sufficient performance
- **Alternative**: Direct Storage Account endpoint (https://st[account].z13.web.core.windows.net/)

### Future: Azure Front Door
When needed for:
- Global content delivery
- DDoS protection
- WAF (Web Application Firewall)
- Traffic acceleration

Can be re-enabled with:
```hcl
sku = "Standard_AzureFrontDoor"
# (requires azurerm_cdn_frontdoor_profile instead of azurerm_cdn_profile)
```

## 🔄 Lifecycle

```
Local Changes
    ↓
Git Commit & Push
    ↓
GitHub Actions Trigger
    ↓
Terraform Validation
    ↓
Infrastructure Planning
    ↓
Terraform Apply
    ↓
Azure Resources Updated
    ↓
Storage Account Synced
    ↓
Website Live (<1 minute)
```

## 🚀 Performance

**Current Setup**:
- **Latency**: ~50-100ms (depends on location)
- **Availability**: 99.9% (SLA by Azure)
- **Replication**: Geographic redundancy (GRS)
- **CDN**: Not needed for static content (very fast)

**If adding Azure Front Door**:
- **Latency**: <20ms (with caching)
- **Availability**: 99.99% (SLA by Azure Front Door)
- **DDoS Protection**: Yes (included)
- **Geographic Caching**: Yes (40+ edge locations)

## 📞 Support & Resources

- **Azure Storage Docs**: [docs.microsoft.com](https://docs.microsoft.com/azure/storage/)
- **Terraform Azure Provider**: [registry.terraform.io](https://registry.terraform.io/providers/hashicorp/azurerm/)
- **GitHub Actions**: [docs.github.com/actions](https://docs.github.com/en/actions)
- **Troubleshooting**: Check GitHub Actions logs in your repository

---

**Last Updated**: December 2, 2025
**Portfolio Status**: ✅ Live and Operational
