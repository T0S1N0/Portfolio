# Arquitectura - Portfolio en Azure

## 🏗️ Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet / Usuarios                      │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────┐
        │      Azure CDN (Content Delivery)      │
        │  cdn-portfolio-prod.azureedge.net      │
        │  - Global caching                      │
        │  - HTTPS/SSL (automático)              │
        │  - Compresión de contenido             │
        └────────────────────┬───────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────┐
        │   Azure Storage Account (Static Site)  │
        │  - index.html                          │
        │  - cv.pdf (opcional)                   │
        │  - Almacenamiento: $web container      │
        └────────────────────┬───────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────┐
        │        Azure Resource Group            │
        │   rg-portfolio-prod (East US)          │
        └────────────────────────────────────────┘
```

## 🔄 Flujo de Despliegue

```
┌─────────────┐
│   Cambios   │
│ en Git Repo │
└──────┬──────┘
       │
       ▼
┌──────────────────────────────┐
│   GitHub Actions Trigger     │
│  (Push a main branch)        │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Validate Terraform Config   │
│  - terraform validate        │
│  - terraform fmt check       │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Plan Infrastructure Changes │
│  - terraform plan            │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Deploy to Azure             │
│  - terraform apply           │
│  - Upload files to Storage   │
│  - Purge CDN cache           │
└──────┬───────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│  Website Live & Updated      │
│  - Usuarios ven cambios      │
│  - CDN distribuye contenido  │
└──────────────────────────────┘
```

## 📊 Componentes Principales

### 1. Azure Storage Account
- **Tipo**: General Purpose v2 (GRS)
- **Ubicación**: East US
- **Hosting**: Static Website habilitado
- **Container**: `$web` (público)
- **Archivos**:
  - `index.html` (sitio web)
  - `cv.pdf` (currículum, opcional)

### 2. Azure CDN Profile
- **SKU**: Standard_Microsoft
- **Origen**: Storage Account Static Website Endpoint
- **Caché**: Habilitado
- **Compresión**: Activa para archivos de texto
- **HTTPS**: Automático

### 3. Terraform
- **Provider**: Azure Resource Manager (azurerm)
- **Backend**: Local (puedes cambiar a remote)
- **Variables**: `location`, `environment`
- **Outputs**: URLs y información de recursos

### 4. GitHub Actions
- **Trigger**: Push a rama `main`
- **Jobs**:
  - `terraform-plan`: Valida y planifica
  - `deploy`: Aplica cambios
  - `validate-deployment`: Prueba sitio

## 🔐 Seguridad

```
┌─────────────────────────────────────┐
│       GitHub Secrets (Encrypted)    │
│  - AZURE_SUBSCRIPTION_ID            │
│  - AZURE_CLIENT_ID                  │
│  - AZURE_CLIENT_SECRET              │
│  - AZURE_TENANT_ID                  │
└──────────────┬──────────────────────┘
               │
               ▼
        ┌──────────────────┐
        │ Service Principal│
        │ (Limited Perms)  │
        └──────────┬───────┘
                   │
                   ▼
        ┌──────────────────┐
        │ Azure Resources  │
        │ (Create/Update)  │
        └──────────────────┘
```

## 💾 Almacenamiento de Estado

### Opción 1: Local (Actual)
```
terraform/
├── .terraform/
├── terraform.tfstate
└── terraform.tfstate.backup
```

### Opción 2: Azure Storage (Recomendado para Equipos)
```
# En main.tf
backend "azurerm" {
  resource_group_name  = "rg-terraform"
  storage_account_name = "tfstateXXXX"
  container_name       = "tfstate"
  key                  = "portfolio.tfstate"
}
```

## 📈 Escalabilidad

```
Usuarios Bajos (0-100/mes)
├── Storage: Pay-as-you-go (~$0.60)
├── CDN: Mínimo/Gratuito
└── Total: < $1/mes

Usuarios Medios (100-10,000/mes)
├── Storage: Reserva Standard (~$1-5)
├── CDN: ~$0.20/GB (~$5-20)
└── Total: $5-25/mes

Usuarios Altos (10,000+/mes)
├── Storage: Reserva Premium (~$5-10)
├── CDN: Descuentos de volumen (~$50+)
└── Total: $50+/mes
```

## 🌍 Ubicaciones de Azure CDN

El CDN replica el contenido en múltiples puntos de presencia:
- USA (Este, Oeste, Centro)
- Europa (Norte, Oeste, Centro)
- Asia (Este, Sudeste)
- Oriente Medio, América Latina, etc.

Esto garantiza baja latencia global (<100ms).

## 🔄 Ciclo de Vida

```
Cambio Local (tu PC)
    ↓
Git Commit & Push
    ↓
GitHub Actions Triggers
    ↓
Terraform Validate
    ↓
Terraform Plan
    ↓
Terraform Apply
    ↓
Azure Resources Updated
    ↓
CDN Purges Cache
    ↓
Usuarios Ven Cambios (30 seg - 5 min)
```

## 📞 Contacto y Soporte

- **Issues**: GitHub Repository Issues
- **Email**: Tu correo
- **LinkedIn**: Tu perfil LinkedIn
- **Documentación**: Azure Docs, Terraform Registry

---

**Última actualización**: 27 de Noviembre, 2025
