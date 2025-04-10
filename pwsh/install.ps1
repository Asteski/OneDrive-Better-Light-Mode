$searchDirList = @(
    "$env:LOCALAPPDATA\Microsoft\OneDrive\",
    "$env:PROGRAMFILES\Microsoft OneDrive\"
)
$newIconList = @(
    "..\assets\FileSync_537.ico",
    "..\assets\FileSync_538.ico"
)
Stop-Process -n OneDrive -Force
ForEach ($searchDir in $searchDirList){
    $dllPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources.dll" -Recurse | Select-Object -First 1 | ForEach-Object { $_.FullName }
    $backupPath = $dllPath.Replace([System.IO.Path]::GetExtension($dllPath), "_backup" + [System.IO.Path]::GetExtension($dllPath))
    Copy-Item -Path $dllPath -Destination $backupPath -Force -ErrorAction SilentlyContinue > $null 2>&1
    ForEach ($newIconPath in $newIconList) {
        $iconGroup = "ICONGROUP," + [int]([regex]::Match($newIconPath, '_(\d+)\.ico$').Groups[1].Value)
        pwsh -NoProfile -Command "..\bin\resourcehacker.exe -open `"$dllPath`" -save `"$dllPath`" -action addoverwrite -res `"$newIconPath`" -mask $iconGroup"
        Start-Sleep -Seconds 1
    }
}
Write-Host "OneDrive Light Mode tray icons have been applied. Please restart OneDrive." -ForegroundColor Green