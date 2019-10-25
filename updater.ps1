$url = "https://raw.githubusercontent.com/DavidNgoDev/FORKIT/master/Forkit.ps1"
$output = "$PSScriptRoot\Forkit"
$start_time = Get-Date
(New-Object System.Net.WebClient).DownloadFile($url, $output)
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
Write-Host "Update Compleat"
./Forkit.ps1