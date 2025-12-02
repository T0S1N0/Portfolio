# GitHub Actions Troubleshooting & Fixes

## Issues Resolved

### 1. ❌ Deprecated Action: `actions/upload-artifact@v3`

**Error**: `This request has been automatically failed because it uses a deprecated version of actions/upload-artifact: v3`

**Fix**: Updated to `actions/upload-artifact@v4`

```yaml
# OLD (v3 - DEPRECATED)
- uses: actions/upload-artifact@v3

# NEW (v4 - CURRENT)
- uses: actions/upload-artifact@v4
  with:
    name: tfplan
    path: terraform/tfplan
    retention-days: 1
    if-no-files-found: warn
```

---

### 2. ❌ Missing Terraform Plan in Deploy Job

**Error**: `terraform: plan file not found`

**Root Cause**: The `terraform-plan` job creates `tfplan` but `deploy` job runs in separate container without access to it

**Fix**: Use `actions/download-artifact@v4` to retrieve plan

```yaml
# In deploy job, before terraform apply:
- name: Download TF Plan Artifact
  uses: actions/download-artifact@v4
  with:
    name: tfplan
    path: terraform/

- name: Terraform Apply
  run: terraform apply -auto-approve tfplan
```

---

### 3. ❌ Hardcoded URL in Validation

**Problem**: URL was hardcoded, causing issues if account name changes

```yaml
# OLD (HARDCODED)
curl -s -I https://stportfolio21ecb97f.z13.web.core.windows.net/
```

**Fix**: Use Terraform outputs dynamically

```yaml
# NEW (DYNAMIC)
- name: Get Portfolio URL
  id: portfolio_url
  run: |
    URL=$(terraform output -raw portfolio_url)
    echo "url=${URL}" >> $GITHUB_OUTPUT

- name: Test Website Health
  run: |
    URL="${{ steps.portfolio_url.outputs.url }}"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${URL}")
```

---

### 4. ⚠️ GitHub Actions Secrets Not Configured

**Error**: `terraform init: Error: Failed to authenticate with Azure`

**Solution**: Ensure these GitHub Secrets are configured:

1. Go to: Repository → Settings → Secrets and variables → Actions
2. Add secrets:
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_CLIENT_ID`
   - `AZURE_CLIENT_SECRET`
   - `AZURE_TENANT_ID`

```bash
# To create Service Principal:
az ad sp create-for-rbac --name "github-portfolio" \
  --role "Contributor" \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

---

### 5. ❌ Azure Authentication Error: "Please run 'az login' to setup account"

**Error**: 
```
ERROR: Please run 'az login' to setup account.
Error: unable to build authorizer for Resource Manager API: 
could not configure AzureCli Authorizer: tenant ID was not specified
```

**Root Cause**: GitHub Secrets for Azure authentication are not configured

**Solution**: Configure GitHub Secrets (see `AZURE_AUTHENTICATION_SETUP.md` for detailed instructions)

Quick steps:
1. Create Azure Service Principal locally:
```bash
az ad sp create-for-rbac --name "github-portfolio" \
  --role "Contributor" \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --json-auth
```

2. Add 4 secrets to GitHub repo (Settings → Secrets → Actions):
   - `AZURE_SUBSCRIPTION_ID` - Your subscription ID
   - `AZURE_CLIENT_ID` - appId from Service Principal
   - `AZURE_CLIENT_SECRET` - password from Service Principal  
   - `AZURE_TENANT_ID` - tenant from Service Principal

3. Re-run GitHub Actions workflow

**See**: `AZURE_AUTHENTICATION_SETUP.md` for complete guide

---

## Workflow Architecture

```
github/workflows/deploy.yml
├── Job 1: terraform-plan
│   ├── Checkout code
│   ├── Terraform format check
│   ├── Terraform init
│   ├── Terraform validate
│   ├── Terraform plan → Creates tfplan
│   └── Upload artifact (v4) → Stores tfplan
│
├── Job 2: deploy (needs: terraform-plan)
│   ├── Download artifact (v4) ← Retrieves tfplan
│   ├── Terraform init
│   ├── Terraform apply tfplan
│   ├── Get outputs (URL)
│   └── Post summary to GitHub
│
└── Job 3: validate-deployment (needs: deploy)
    ├── Terraform init (read-only)
    ├── Get URL from terraform output
    ├── Test HTTP response code
    └── Post validation results
```

---

## Common Issues & Solutions

### Issue: "No such file or directory: terraform/tfplan"

**Cause**: Download artifact step failed or artifact name mismatch

**Solution**:

1. Check artifact upload in terraform-plan job:

   ```yaml
   - uses: actions/upload-artifact@v4
     with:
       name: tfplan
       path: terraform/tfplan
   ```

2. Check artifact download uses same name:
   ```yaml
   - uses: actions/download-artifact@v4
     with:
       name: tfplan # Must match upload
       path: terraform/
   ```

---

### Issue: "terraform output: No outputs to show"

**Cause**: Terraform state has no outputs defined

**Solution**: Verify `terraform/outputs.tf` exists and has content:

```hcl
output "portfolio_url" {
  value = azurerm_storage_account.portfolio.primary_web_endpoint
}
```

---

### Issue: "curl: (7) Failed to connect"

**Cause**: Website not yet deployed or URL is incorrect

**Solution**:

1. Check deployment succeeded in deploy job logs
2. Check URL is correct: `https://st[account].z13.web.core.windows.net/`
3. Wait 1-2 minutes for DNS propagation

---

### Issue: "GITHUB_OUTPUT: No such file"

**Cause**: Running on incompatible GitHub Actions runner

**Solution**: Ensure runner is `ubuntu-latest`:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest # Must be this
```

---

## Testing Workflow Locally

```bash
# 1. Install act (local GitHub Actions runner)
brew install act  # or for Windows: choco install act

# 2. Set up .env with secrets
cat > .env << EOF
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_CLIENT_ID=your-client-id
AZURE_CLIENT_SECRET=your-client-secret
AZURE_TENANT_ID=your-tenant-id
EOF

# 3. Run workflow locally
act -j terraform-plan -j deploy -j validate-deployment --env-file .env

# 4. View logs
act -l  # List all workflows
```

---

## Monitoring Deployments

### View Workflow Runs

1. GitHub repo → Actions tab
2. Click on workflow name
3. View job details and logs

### Check Terraform State

```bash
# Authenticate to Azure
az login --service-principal -u $AZURE_CLIENT_ID \
  -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID

# View Azure resources
az resource list --resource-group rg-portfolio-prod

# Check Storage Account
az storage account show --resource-group rg-portfolio-prod
```

---

## GitHub Actions v4 Changes

### Upload Artifact v4

**Key Changes from v3 → v4**:

- Path format unchanged
- Added `retention-days` parameter
- Added `if-no-files-found` option (warn/error/ignore)
- Better error handling
- Improved performance

### Download Artifact v4

**Key Changes**:

- Simpler syntax
- Auto-handles multiple artifacts
- Better path resolution
- Improved error messages

---

## Next Steps

1. ✅ Verify workflow runs without errors
2. ✅ Check deployment summary in GitHub Actions
3. ✅ Visit portfolio URL from summary
4. ✅ Monitor Azure Portal for resource updates
5. ✅ Set up cost alerts if needed

---

**Last Updated**: December 2, 2025
**Status**: All issues resolved ✅
