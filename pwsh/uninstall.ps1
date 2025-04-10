Write-Host @"
-----------------------------------------------------------------------

Welcome to OneDrive Better Light Mode Deployment!

Author: Asteski
GitHub: https://github.com/Asteski/OneDrive-Better-Light-Mode

This is work in progress. You're using this script at your own risk.

-----------------------------------------------------------------------

"@ -ForegroundColor Cyan
Start-Sleep 1
for ($a=3; $a -ge 0; $a--) {
    Write-Host "`rOneDrive Light Mode tray icons will be now restored in $a" -NoNewline -ForegroundColor Yellow
    Start-Sleep 1
}
Write-Host "`r" -NoNewline
Write-Host "OneDrive Light Mode tray icons restore is starting..." -ForegroundColor Yellow
Stop-Process -n OneDrive -Force -ErrorAction SilentlyContinue
$searchDirList = @(
    "$env:LOCALAPPDATA\Microsoft\OneDrive\",
    "$env:PROGRAMFILES\Microsoft OneDrive\"
)
ForEach ($searchDir in $searchDirList){
    $dllPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 | ForEach-Object { $_.FullName }
    if ($dllPath) {
        $backupPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources_backup.dll" -Recurse | Select-Object -First 1 | ForEach-Object { $_.FullName }
        Copy-Item -Path $backupPath -Destination $dllPath -Force -ErrorAction SilentlyContinue
        Remove-Item $backupPath -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    }
}
Write-Host "OneDrive Light Mode tray icons have been restored. Please restart OneDrive." -ForegroundColor Green