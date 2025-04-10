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
    Write-Host "`rOneDrive Light Mode tray icons will be now applied in $a." -NoNewline -ForegroundColor Yellow
    Start-Sleep 1
}
Write-Host "`rOneDrive Light Mode tray icons deployment..." -NoNewline
$searchDirList = @(
    "$env:LOCALAPPDATA\Microsoft\OneDrive\",
    "$env:PROGRAMFILES\Microsoft OneDrive\"
)
$newIconList = Get-ChildItem -Path "$PSScriptRoot\..\assets" -Filter "FileSync_*.ico" | ForEach-Object { $_.FullName }
Stop-Process -n OneDrive -Force -ErrorAction SilentlyContinue
ForEach ($searchDir in $searchDirList){
    $dllPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 | ForEach-Object { $_.FullName }
    if ($null -ne $dllPath) {
        $backupPath = $dllPath.Replace([System.IO.Path]::GetExtension($dllPath), "_backup" + [System.IO.Path]::GetExtension($dllPath))
        Copy-Item -Path $dllPath -Destination $backupPath -Force -ErrorAction SilentlyContinue
        ForEach ($newIconPath in $newIconList) {
            $iconGroup = "ICONGROUP," + [int]([regex]::Match($newIconPath, '_(\d+)\.ico$').Groups[1].Value)
            ..\bin\ResourceHacker.exe -open $dllPath -save $dllPath -action addoverwrite -res $newIconPath -mask $iconGroup
            Start-Sleep -Seconds 1
        }
    }
}
Start-Sleep 1
Write-Host "`nOneDrive Light Mode tray icons have been applied. Please restart OneDrive." -ForegroundColor Green