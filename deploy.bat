@echo off
REM Script para desplegar el portfolio en Azure localmente (Windows)

setlocal enabledelayedexpansion

echo.
echo ========================================
echo     Portfolio Azure Deployment
echo ========================================
echo.

REM Colores no disponibles en Windows CMD, usar caracteres especiales

REM Verificar si Terraform está instalado
where terraform >nul 2>nul
if !errorlevel! neq 0 (
    echo [ERROR] Terraform no esta instalado
    echo Descargalo desde: https://www.terraform.io/downloads.html
    pause
    exit /b 1
)

REM Verificar si Azure CLI está instalado
where az >nul 2>nul
if !errorlevel! neq 0 (
    echo [ERROR] Azure CLI no esta instalado
    echo Descargalo desde: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
    pause
    exit /b 1
)

REM Verificar autenticación en Azure
az account show >nul 2>nul
if !errorlevel! neq 0 (
    echo [WARNING] No estas autenticado en Azure
    echo Ejecuta: az login
    pause
    exit /b 1
)

echo [OK] Verificaciones completadas
echo.

REM Cambiar a directorio de terraform
cd terraform

REM Inicializar Terraform
echo [INFO] Inicializando Terraform...
call terraform init

REM Validar configuración
echo.
echo [INFO] Validando configuracion...
call terraform validate

REM Formatear código
echo.
echo [INFO] Formateando codigo Terraform...
call terraform fmt -recursive

REM Planificar cambios
echo.
echo [INFO] Planificando cambios...
call terraform plan -out=tfplan

REM Preguntar antes de aplicar
echo.
echo [WARNING] Este comando aplicara los cambios en Azure
set /p response="Deseas continuar? (s/n): "

if /i not "%response%"=="s" (
    echo Despliegue cancelado
    cd ..
    exit /b 0
)

REM Aplicar cambios
echo.
echo [INFO] Aplicando cambios...
call terraform apply tfplan

REM Mostrar outputs
echo.
echo [OK] Despliegue completado
echo.
echo Outputs de Terraform:
call terraform output

cd ..

echo.
echo [OK] Tu portfolio esta listo!
echo.
echo Siguiente: Copia tu CV como 'cv.pdf' en el directorio raiz
echo           y ejecuta este script nuevamente para actualizar.
echo.
pause
