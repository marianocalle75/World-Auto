@echo off
title Servidor GTA Mundial
cd /d "%~dp0"

set "PAGINA=GTA Mundial.html"
set "PUERTO=8000"

rem --- Comprobar que existen la pagina y la carpeta de Cesium ---
if not exist "%PAGINA%" (
    echo No encuentro "%PAGINA%" en esta carpeta:
    echo %cd%
    echo Copia este archivo .bat junto a la pagina y a la carpeta Cesium.
    pause
    exit /b 1
)
if not exist "Cesium\Cesium.js" (
    echo No encuentro la carpeta Cesium\ junto a la pagina.
    pause
    exit /b 1
)

rem --- Comprobar que Node.js esta instalado ---
where npx >nul 2>nul
if errorlevel 1 (
    echo Node.js no esta instalado. Descargalo desde https://nodejs.org y vuelve a abrir este archivo.
    pause
    exit /b 1
)

rem --- Si el servidor ya esta corriendo, solo abrir la pagina ---
netstat -ano | findstr /R /C:":%PUERTO% .*LISTENING" >nul
if not errorlevel 1 (
    echo El servidor ya estaba iniciado. Abriendo la pagina...
    start "" "http://localhost:%PUERTO%/GTA%%20Mundial.html"
    exit /b 0
)

rem --- Abrir el navegador cuando el servidor ya responda (espera hasta 30 s) ---
start "" /b powershell -NoProfile -Command "$ok=$false; for($i=0;$i -lt 60 -and -not $ok;$i++){ try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 1 'http://localhost:%PUERTO%/' | Out-Null; $ok=$true } catch { Start-Sleep -Milliseconds 500 } }; Start-Process 'http://localhost:%PUERTO%/GTA%%20Mundial.html'"

echo ================================================
echo  Servidor iniciado en http://localhost:%PUERTO%
echo  Cierra esta ventana para detenerlo.
echo ================================================
call npx --yes http-server . -p %PUERTO% -c-1

echo.
echo El servidor se detuvo.
pause
