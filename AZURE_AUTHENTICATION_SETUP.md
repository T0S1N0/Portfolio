# Azure Authentication Setup for GitHub Actions

## Error
```
ERROR: Please run 'az login' to setup account.
Error: unable to build authorizer for Resource Manager API
```

## Root Cause
GitHub Actions está intentando autenticarse con Azure pero no tiene las credenciales configuradas en los **GitHub Secrets**.

## Solution: Configure Azure Secrets in GitHub

### Step 1: Create Azure Service Principal

Run this command locally (requires Azure CLI):

```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Create Service Principal with Contributor role
az ad sp create-for-rbac \
  --name "github-portfolio-deployment" \
  --role "Contributor" \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --json-auth
```

This will output something like:
```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "github-portfolio-deployment",
  "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### Step 2: Add Secrets to GitHub Repository

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these 4 secrets:

| Secret Name | Value | Source |
|-------------|-------|--------|
| `AZURE_SUBSCRIPTION_ID` | Your subscription ID (79a2d831-3f82-430f-b4ce-28d5249bdd2d) | From `az account show` |
| `AZURE_CLIENT_ID` | `appId` from SP output | From previous command |
| `AZURE_CLIENT_SECRET` | `password` from SP output | From previous command |
| `AZURE_TENANT_ID` | `tenant` from SP output | From previous command |

### Step 3: Verify Secrets Configuration

Run this to test:
```bash
# The workflow will use these secrets automatically
# No manual testing needed - just trigger a new workflow run
```

## GitHub Actions Workflow Usage

The secrets are automatically used by GitHub Actions via environment variables:

```yaml
env:
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
  ARM_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
  ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
```

## Testing Locally

To test authentication locally before pushing:

```bash
# Set environment variables
export ARM_SUBSCRIPTION_ID="79a2d831-3f82-430f-b4ce-28d5249bdd2d"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"

# Or use Azure CLI
az login

# Test Terraform
cd terraform
terraform init
terraform plan
```

## Security Best Practices

⚠️ **Important**: Never commit secrets to Git!

✅ **Do**:
- Use GitHub Secrets for sensitive data
- Rotate secrets periodically
- Use minimal permissions (Contributor on specific scope)
- Delete unused Service Principals

❌ **Don't**:
- Hardcode credentials in workflow files
- Share credentials in commits or PRs
- Use subscriptions without RBAC restrictions
- Keep unused credentials

## Troubleshooting

### "Tenant ID was not specified"
- Make sure `AZURE_TENANT_ID` secret is configured
- Check the value is correct (should be a UUID)

### "Error logging in with service principal"
- Verify `AZURE_CLIENT_ID` and `AZURE_CLIENT_SECRET` are correct
- Check Service Principal has Contributor role
- Ensure subscription ID is correct

### "Access Denied"
- Service Principal may not have permissions
- Check role assignment: `az role assignment list --assignee APP_ID`
- Verify scope is correct

### Workflow Still Failing After Adding Secrets
- Secrets take ~1 minute to propagate
- Try triggering workflow again after waiting
- Check secret names match exactly in workflow YAML

## Rotating Credentials

When you need to update credentials:

```bash
# Create new Service Principal
az ad sp create-for-rbac \
  --name "github-portfolio-deployment-v2" \
  --role "Contributor" \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# Update GitHub Secrets with new credentials

# Delete old Service Principal
az ad sp delete --id OLD_APP_ID
```

---

**Once secrets are configured, GitHub Actions will automatically authenticate with Azure and deploy your infrastructure.**

**Last Updated**: December 2, 2025
