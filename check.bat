@echo off
REM Verificación previa a despliegue - Portfolio Azure (Windows)

setlocal enabledelayedexpansion
cd /d "%~dp0"

echo.
echo =========================================================
echo    Portfolio Azure - Pre-Deployment Checklist
echo =========================================================
echo.

set CHECKS_PASSED=0
set CHECKS_FAILED=0
set CHECKS_TOTAL=0

REM Sección 1: Herramientas
echo [1] Verificando Herramientas Requeridas
echo =====================================================
where terraform >nul 2>nul
if !errorlevel! equ 0 (
    echo [OK] Terraform esta instalado
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] Terraform NO esta instalado
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1

where az >nul 2>nul
if !errorlevel! equ 0 (
    echo [OK] Azure CLI esta instalado
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] Azure CLI NO esta instalado
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1

where git >nul 2>nul
if !errorlevel! equ 0 (
    echo [OK] Git esta instalado
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] Git NO esta instalado
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1

echo.

REM Sección 2: Archivos
echo [2] Verificando Archivos del Proyecto
echo =====================================================
if exist "index.html" (
    echo [OK] index.html existe
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] index.html NO existe
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1

if exist "terraform\main.tf" (
    echo [OK] terraform\main.tf existe
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] terraform\main.tf NO existe
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1

if exist ".github\workflows\deploy.yml" (
    echo [OK] .github\workflows\deploy.yml existe
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] .github\workflows\deploy.yml NO existe
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1

echo.

REM Sección 3: Azure Auth
echo [3] Verificando Autenticacion Azure
echo =====================================================
az account show >nul 2>nul
if !errorlevel! equ 0 (
    for /f "delims=" %%i in ('az account show --query name -o tsv') do set ACCOUNT=%%i
    echo [OK] Autenticado en Azure: !ACCOUNT!
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] NO autenticado en Azure
    echo         Ejecuta: az login
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1

echo.

REM Sección 4: Terraform validation
echo [4] Verificando Configuracion Terraform
echo =====================================================
cd terraform
terraform validate >nul 2>nul
if !errorlevel! equ 0 (
    echo [OK] Configuracion Terraform valida
    set /a CHECKS_PASSED+=1
) else (
    echo [ERROR] Errores en configuracion Terraform
    echo         Ejecuta: terraform validate
    set /a CHECKS_FAILED+=1
)
set /a CHECKS_TOTAL+=1
cd ..

echo.

REM Resumen
echo =========================================================
echo RESUMEN
echo =========================================================
echo.
echo Total verificaciones: !CHECKS_TOTAL!
echo [OK] Pasaron: !CHECKS_PASSED!
echo [ERROR] Fallaron: !CHECKS_FAILED!
echo.

if !CHECKS_FAILED! equ 0 (
    echo [OK] Estas listo para desplegar!
    echo.
    echo Proximos pasos:
    echo   1. cd terraform
    echo   2. terraform plan
    echo   3. terraform apply
    echo.
    pause
    exit /b 0
) else (
    echo [ERROR] Hay problemas que resolver
    echo.
    echo Por favor:
    echo   1. Instala las herramientas faltantes
    echo   2. Verifica que estes autenticado en Azure
    echo   3. Ejecuta az login si es necesario
    echo.
    pause
    exit /b 1
)
