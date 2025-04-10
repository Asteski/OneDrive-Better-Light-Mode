@echo off
cd /d "%~dp0\pwsh"
if "%1"=="" (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "install.ps1"
) else if /i "%1"=="-uninstall" (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "uninstall.ps1"
) else if /i "%1"=="-u" (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "uninstall.ps1"
) else (
    echo [31mInvalid argument.[0m
)