$ErrorActionPreference = "SilentlyContinue"
Write-Host @"
-----------------------------------------------------------------------

Welcome to OneDrive Better Light Mode Deployment!

Author: Asteski
GitHub: https://github.com/Asteski/OneDrive-Better-Light-Mode

This is work in progress. You're using this script at your own risk.

-----------------------------------------------------------------------
"@ -ForegroundColor Cyan
Start-Sleep 1
Write-Host
for ($a=3; $a -ge 0; $a--) {
    Write-Host "`rOneDrive Light Mode tray icons will be applied in $a" -NoNewline -ForegroundColor Yellow
    Start-Sleep 1
}
Write-Host "`r" -NoNewline
Write-Host "OneDrive Light Mode tray icons deployment is starting..." -ForegroundColor Yellow
Stop-Process -n OneDrive -Force
$searchDirList = @(
    "$env:LOCALAPPDATA\Microsoft\OneDrive\",
    "$env:PROGRAMFILES\Microsoft OneDrive\"
)
$newIconList = Get-ChildItem -Path "$PSScriptRoot\..\assets" -Filter "FileSync_*.ico" | ForEach-Object { $_.FullName }
ForEach ($searchDir in $searchDirList){
    $dllPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources.dll" -Recurse | Select-Object -First 1 | ForEach-Object { $_.FullName }
    if ($dllPath) {
        Write-Host "`nFound FileSync.Resources.dll in $(Split-Path -Path $dllPath -Parent)" -ForegroundColor DarkYellow
        Write-Host "Backing up $dllPath" -ForegroundColor DarkYellow
        $backupPath = $dllPath.Replace([System.IO.Path]::GetExtension($dllPath), "_backup" + [System.IO.Path]::GetExtension($dllPath))
        Write-Host "Backup path: $backupPath" -ForegroundColor DarkYellow
        Copy-Item -Path $dllPath -Destination $backupPath -Force
        Write-Host "Applying new icons..." -ForegroundColor DarkYellow
        ForEach ($newIconPath in $newIconList) {
            $iconGroup = "ICONGROUP," + [int]([regex]::Match($newIconPath, '_(\d+)\.ico$').Groups[1].Value)
            ..\bin\ResourceHacker.exe -open $dllPath -save $dllPath -action addoverwrite -res $newIconPath -mask $iconGroup
            Start-Sleep -Seconds 1
        }
    }
}
Start-Sleep 1
Write-Host "`nOneDrive Light Mode tray icons have been applied. Please restart OneDrive." -ForegroundColor Green