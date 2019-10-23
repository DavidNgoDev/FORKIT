Import-Module ActiveDirectory

# Checking if script was ran with administrative privledges
#Requires -RunAsAdministrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host "This Script Needs To Be Ran With Administrative Privledges" -ForegroundColor Red
  Write-Host "Right Click The Script and Run With Admin. Thanks!" -ForegroundColor Red
  Read-Host  "Press any key to continue"
  exit
}

# Auto Script Update
$currentVersion = "1.0"
$url = "http://mirror.internode.on.net/pub/test/10meg.test"
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$output = "$DesktopPath\10meg.test"
$start_time = Get-Date
(New-Object System.Net.WebClient).DownloadFile($url, $output)
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
echo "CSV Template Downloaded and Saved to Desktop"
$latestVersion = ""

cls

function Show-Menu {
Write-Host "    __________  ____  __ __ __________" -ForegroundColor Green 
Write-Host "   / ____/ __ \/ __ \/ //_//  _/_  __/" -ForegroundColor Green 
Write-Host "  / /_  / / / / /_/ / ,<   / /  / /   " -ForegroundColor Green 
Write-Host " / __/ / /_/ / _, _/ /| |_/ /  / /    " -ForegroundColor Green 
Write-Host "/_/    \____/_/ |_/_/ |_/___/ /_/     " -ForegroundColor Green
echo "                                      "
echo "--------------------------------------"
echo "| Made By David Ngo      Version 1.0 |"
echo "--------------------------------------"
echo "                                      "                                      
echo "   What Would You Like To Do Today?   "
echo "                                      " 
echo "--------------------------------------"
echo "| Option Menu                [-] [X] |"
echo "--------------------------------------"
echo "| 1) Create AD DS CSV Template File  |"
echo "| 2) Import CSV File For AD DS       |"
echo "| 3) Add Users                       |"
echo "| 4) Delete Users                    |"
echo "| 5) Block User Access               |"
echo "| 6) Reset User Password             |"
echo "| 7) Apply GPO To User or OU         |"
echo "--------------------------------------"      
echo "                                      "
}

function Import-CSV-File {
    $filePath = Read-Host -Prompt "Please Enter or Drag Your CSV Path Here"
    $users = Import-Csv $filePath
    ForEach ($user in $user) {
        $firstName = $user.'First Name'
        $lastName = $user.'Last Name'
        $password = $user.Password
        $jobTitle = $user.'Job Title'
        $officePhone = $user.'Office Phone'
        $emailAddress = $user.'Email Address'
        $description = $user.Description
        $OUpath = $user.'Organisational Unit'
        $securePassword = ConvertTo-SecureString "$password" -AsPlainText -Force
        $lastNameUp = ($lastName.ToUpper())
        $Final = $firstName + $lastNameUp[0]
        New-ADuser -Name "$firstName $lastName" -DisplayName "$firstName $lastName" -GivenName $firstName -Surname $lastName -UserPrincipalName "$Final" -Path $OUpath -AccountPassword $securePassword -ChangePasswordAtLogon $True -OfficePhone $officePhone -Description $Description -EmailAddress $emailAddress -Enabled $True
        echo "$firstName $lastName was sucessfully added to $OUpath"
    }
}

Show-Menu
do
{
     $input = Read-Host "Please make a selection or 'q' to quit"
     echo "                                      "
     switch ($input)
     {
           '1' {
                 $url = "http://mirror.internode.on.net/pub/test/10meg.test"
                 $DesktopPath = [Environment]::GetFolderPath("Desktop")
                 $output = "$DesktopPath\10meg.test"
                 $start_time = Get-Date
                 (New-Object System.Net.WebClient).DownloadFile($url, $output)
                 Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
                 echo "CSV Template Downloaded and Saved to Desktop"
                 pause          
                 cls
                 Show-Menu
           } '2' {
                 echo "--------------------------------------"
                 echo "| User Input Needed              [x] |"
                 echo "--------------------------------------"
                 echo "                                      "   
                 Import-CSV-File
           } '3' {

                'You chose option #3'
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q') 


