#!/bin/bash
# Script para desplegar el portfolio en Azure localmente

set -e

echo "🚀 Desplegando Portfolio en Azure..."
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar si Terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}❌ Terraform no está instalado${NC}"
    echo "Descárgalo desde: https://www.terraform.io/downloads.html"
    exit 1
fi

# Verificar si Azure CLI está instalado
if ! command -v az &> /dev/null; then
    echo -e "${RED}❌ Azure CLI no está instalado${NC}"
    echo "Descárgalo desde: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Verificar autenticación en Azure
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}⚠️  No estás autenticado en Azure${NC}"
    echo "Ejecuta: az login"
    exit 1
fi

echo -e "${GREEN}✓ Verificaciones completadas${NC}"
echo ""

# Cambiar a directorio de terraform
cd terraform

# Inicializar Terraform
echo "📦 Inicializando Terraform..."
terraform init

# Validar configuración
echo -e "\n${YELLOW}🔍 Validando configuración${NC}"
terraform validate

# Formatear código
echo -e "\n${YELLOW}🎨 Formateando código Terraform${NC}"
terraform fmt -recursive

# Planificar cambios
echo -e "\n${YELLOW}📋 Planificando cambios${NC}"
terraform plan -out=tfplan

# Preguntar antes de aplicar
echo -e "\n${YELLOW}⚠️  Este comando aplicará los cambios en Azure${NC}"
read -p "¿Deseas continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo -e "${RED}Despliegue cancelado${NC}"
    exit 1
fi

# Aplicar cambios
echo -e "\n${GREEN}🚀 Aplicando cambios${NC}"
terraform apply tfplan

# Mostrar outputs
echo -e "\n${GREEN}✓ Despliegue completado${NC}"
echo ""
echo "📊 Outputs de Terraform:"
terraform output

echo ""
echo -e "${GREEN}✓ ¡Tu portfolio está listo!${NC}"
echo ""
echo "Siguiente: Copia tu CV como 'cv.pdf' en el directorio raíz"
echo "           y ejecuta este script nuevamente para actualizar."
