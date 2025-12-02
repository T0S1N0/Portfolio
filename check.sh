#!/usr/bin/env bash
# Verificación previa a despliegue - Portfolio Azure

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Portfolio Azure - Pre-Deployment Checklist${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════${NC}\n"

CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_TOTAL=0

check_command() {
    local cmd=$1
    local display_name=$2
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}✓${NC} $display_name está instalado"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $display_name NO está instalado"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
    fi
}

check_file() {
    local file=$1
    local display_name=$2
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $display_name existe"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $display_name NO existe"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
    fi
}

check_env_var() {
    local var=$1
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    
    if [ -z "${!var}" ]; then
        echo -e "${YELLOW}⚠${NC}  $var no configurado (será necesario para despliegue)"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
    else
        echo -e "${GREEN}✓${NC} $var configurado"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    fi
}

# Sección 1: Herramientas
echo -e "${BLUE}1️⃣  Verificando Herramientas Requeridas${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_command "terraform" "Terraform"
check_command "az" "Azure CLI"
check_command "git" "Git"
echo ""

# Sección 2: Archivos Proyecto
echo -e "${BLUE}2️⃣  Verificando Archivos del Proyecto${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_file "index.html" "index.html"
check_file "terraform/main.tf" "terraform/main.tf"
check_file "terraform/storage.tf" "terraform/storage.tf"
check_file "terraform/cdn.tf" "terraform/cdn.tf"
check_file ".github/workflows/deploy.yml" ".github/workflows/deploy.yml"
check_file "README.md" "README.md"
check_file "SETUP.md" "SETUP.md"
echo ""

# Sección 3: Autenticación Azure
echo -e "${BLUE}3️⃣  Verificando Autenticación Azure${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if az account show &> /dev/null; then
    ACCOUNT=$(az account show --query "name" -o tsv)
    SUBSCRIPTION=$(az account show --query "id" -o tsv)
    echo -e "${GREEN}✓${NC} Autenticado en Azure"
    echo -e "  Cuenta: $ACCOUNT"
    echo -e "  Subscription: $SUBSCRIPTION"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}✗${NC} NO autenticado en Azure"
    echo -e "  Ejecuta: ${YELLOW}az login${NC}"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Sección 4: Variables de Entorno
echo -e "${BLUE}4️⃣  Verificando Variables de Azure (para Terraform)${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_env_var "ARM_SUBSCRIPTION_ID"
check_env_var "ARM_CLIENT_ID"
check_env_var "ARM_CLIENT_SECRET"
check_env_var "ARM_TENANT_ID"
echo ""

# Sección 5: Terraform
echo -e "${BLUE}5️⃣  Verificando Configuración Terraform${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd terraform

if terraform validate &> /dev/null; then
    echo -e "${GREEN}✓${NC} Configuración Terraform válida"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}✗${NC} Errores en configuración Terraform"
    echo -e "  Ejecuta: ${YELLOW}terraform validate${NC}"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))

if [ -f ".terraform/terraform.tfstate" ] || [ -d ".terraform" ]; then
    echo -e "${GREEN}✓${NC} Terraform ya inicializado"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${YELLOW}⚠${NC}  Terraform no inicializado (ejecuta: terraform init)"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))

cd ..
echo ""

# Resumen final
echo -e "${BLUE}════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📊 RESUMEN${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════${NC}"
echo ""
echo -e "Total de verificaciones: ${BLUE}$CHECKS_TOTAL${NC}"
echo -e "✓ Pasaron: ${GREEN}$CHECKS_PASSED${NC}"
echo -e "✗ Fallaron: ${RED}$CHECKS_FAILED${NC}"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ ¡Estás listo para desplegar!${NC}"
    echo ""
    echo "Próximos pasos:"
    echo "  1. cd terraform"
    echo "  2. terraform plan"
    echo "  3. terraform apply"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Hay problemas que resolver antes de desplegar${NC}"
    echo ""
    echo "Por favor:"
    echo "  1. Instala las herramientas faltantes"
    echo "  2. Verifica que estés autenticado en Azure"
    echo "  3. Configura las variables de entorno ARM_*"
    echo ""
    exit 1
fi
