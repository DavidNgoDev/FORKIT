$url = "https://raw.githubusercontent.com/DavidNgoDev/FORKIT/master/updater.ps1"
$output = "$PSScriptRoot\updater.ps1"
# Make a verifier script to replace active script and del old script
$start_time = Get-Date
(New-Object System.Net.WebClient).DownloadFile($url, $output)
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
Write-Host "CSV Template Downloaded and Saved to Desktop"