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
$newIconList = Get-ChildItem -Path "$PSScriptRoot\..\assets" -Filter 'FileSync_*.ico' | ForEach-Object { $_.FullName }
$exeIconPath = Get-ChildItem -Path "$PSScriptRoot\..\assets" -Filter 'IconGroup552.ico' | Select-Object -First 1 | ForEach-Object { $_.FullName }
ForEach ($searchDir in $searchDirList){
    $dllPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources.dll" -Recurse | Select-Object -First 1 | ForEach-Object { $_.FullName }
    if ($dllPath) {
        Write-Host "Found FileSync.Resources.dll in $(Split-Path -Path $dllPath -Parent)" -ForegroundColor DarkYellow
        $backupPath = $dllPath.Replace([System.IO.Path]::GetExtension($dllPath), "_backup" + [System.IO.Path]::GetExtension($dllPath))
        Write-Host "Backup path: $backupPath" -ForegroundColor DarkYellow
        Write-Host "Found OneDrive.exe in $(Split-Path -Path $dllPath -Parent)" -ForegroundColor DarkYellow
        $exePath = Get-ChildItem -Path $searchDir -Filter "OneDrive.exe" -Recurse | Select-Object -First 1 | ForEach-Object { $_.FullName }
        $backupPath = $exePath.Replace([System.IO.Path]::GetExtension($exePath), "_backup" + [System.IO.Path]::GetExtension($exePath))
        Write-Host "Backup path: $backupPath" -ForegroundColor DarkYellow
        Copy-Item -Path $exePath -Destination $backupPath -Force
        Write-Host "Applying new icons..." -ForegroundColor Yellow
        ForEach ($newIconPath in $newIconList) {
            $iconGroup = "ICONGROUP," + [int]([regex]::Match($newIconPath, '_(\d+)\.ico$').Groups[1].Value)
            ..\bin\ResourceHacker.exe -open $dllPath -save $dllPath -action addoverwrite -res $newIconPath -mask $iconGroup > $null 2>&1
            Start-Sleep -Seconds 1
        }
        ..\bin\ResourceHacker.exe -open $exePath -save $exePath -action addoverwrite -res $exeIconPath -mask ICONGROUP,552 > $null 2>&1
        Start-Sleep -Seconds 1
    }
}

Start-Sleep 1
Write-Host "OneDrive Light Mode tray icons have been applied. Please restart OneDrive." -ForegroundColor Green