Stop-Process -n OneDrive -Force
$searchDirList = @(
    "$env:LOCALAPPDATA\Microsoft\OneDrive\",
    "$env:PROGRAMFILES\Microsoft OneDrive\"
)
ForEach ($searchDir in $searchDirList){
    $dllPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources.dll" -Recurse | Select-Object -First 1 | ForEach-Object { $_.FullName }
    $backupPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources_backup.dll" -Recurse | Select-Object -First 1 | ForEach-Object { $_.FullName }
    if ($backupPath) {
        Copy-Item -Path $backupPath -Destination $dllPath -Force -ErrorAction SilentlyContinue
        Remove-Item $backupPath -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    }
}
Write-Host "OneDrive Light Mode tray icons have been restored. Please restart OneDrive." -ForegroundColor Green