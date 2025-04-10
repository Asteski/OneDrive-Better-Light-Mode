$searchDirList = @(
    "$env:LOCALAPPDATA\Microsoft\OneDrive\",
    "$env:PROGRAMFILES\Microsoft OneDrive\"
)
$newIconList = Get-ChildItem -Path "$PSScriptRoot\..\assets" -Filter "FileSync_*.ico" | ForEach-Object { $_.FullName }
Stop-Process -n OneDrive -Force
ForEach ($searchDir in $searchDirList){
    $dllPath = Get-ChildItem -Path $searchDir -Filter "FileSync.Resources.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 | ForEach-Object { $_.FullName }
    if ($null -ne $dllPath) {
        $backupPath = $dllPath.Replace([System.IO.Path]::GetExtension($dllPath), "_backup" + [System.IO.Path]::GetExtension($dllPath))
        Copy-Item -Path $dllPath -Destination $backupPath -Force -ErrorAction SilentlyContinue
        ForEach ($newIconPath in $newIconList) {
            $iconGroup = "ICONGROUP," + [int]([regex]::Match($newIconPath, '_(\d+)\.ico$').Groups[1].Value)
            ..\bin\resourcehacker.exe -open $dllPath -save $dllPath -action addoverwrite -res $newIconPath -mask $iconGroup
            Start-Sleep -Seconds 1
        }
    }
}
Stop-Process -n Explorer -Force
Write-Host "OneDrive Light Mode tray icons have been applied. Please restart OneDrive." -ForegroundColor Green